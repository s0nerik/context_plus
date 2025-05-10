import itertools
from typing import Iterable

# Returns true if the type string contains either {{i}} or {{i + 1}} placeholders
def _contains_placeholders(type_str: str) -> bool:
    return '{{i}}' in type_str or '{{i + 1}}' in type_str

# Returns true if the type string contains both {{i}} and {{i + 1}} placeholders
def _contains_both_placeholders(type_str: str) -> bool:
    return '{{i}}' in type_str and '{{i + 1}}' in type_str

# Replaces the {{i}} and {{i + 1}} placeholders in the type string with the given placeholder index
def _replace_placeholders(type_str: str, placeholder_index: int) -> str:
    return type_str.replace('{{i}}', str(placeholder_index)).replace('{{i + 1}}', str(placeholder_index + 1))

# Returns the type inside the generic parentheses or None if no generic type is present
def _extract_type_generic(type_str: str) -> str | None:
    if '<' not in type_str or '>' not in type_str:
        return None
    result = type_str[type_str.index('<') + 1 : type_str.index('>')]
    assert result.count(',') == 0, f'Generic type {type_str} contains multiple generic types'
    return result

# Returns the type after the 'extends' keyword or None if no 'extends' keyword is present
def _extract_extended_type(type_str: str) -> str | None:
    if ' extends ' not in type_str:
        return None
    return type_str[type_str.index(' extends ') + len(' extends '):]

# watchOnly(): Returns the default value for a given parameter of the selector callback
def _watchOnly_default_selector_arg(param_index: int, placeholder_index: int, generic_in: str, type_out: str, of_context: bool = False) -> str:
    if 'extends Listenable' in generic_in:
        return f'${param_index + 1}' if not of_context else f'${param_index + 1}.of(context)'
    elif 'extends ValueListenable' in generic_in:
        return f'${param_index + 1}.value' if not of_context else f'${param_index + 1}.of(context).value'
    elif 'Future' in generic_in or 'Stream' in generic_in:
        return f'{_replace_placeholders(type_out, placeholder_index)}.nothing()'
    else:
        raise AssertionError(f'Unknown generic_in: {generic_in}')

class RecordTypeCombination:
    def __init__(self, index: int, param_types: list[tuple[str, str, str, str]]):
        self.index = index

        self.generic_types = [] # "on" types
        self.types_in = []      # "on" types without `extends` section
        self.types_out = []     # Returned value types
        self.obs_types = []     # Types to be used as a generic parameter for `getOrCreateObservable` call
        self.context_watcher_observable_types = [] # ContextWatcherObservableType enum values

        self.record_params = [f'${i + 1}' for i in range(len(param_types))]
        self.record_params_str = ', '.join(self.record_params)
        self.record_params_of_context = [f'${i + 1}.of(context)' for i in range(len(param_types))]
        self.record_params_of_context_str = ', '.join(self.record_params_of_context)
        
        default_selector_values: list[str] = []
        default_selector_values_of_context: list[str] = []

        param_index = 0
        placeholder_index = 0
        for generic_in, type_out, obs_type, context_watcher_observable_type in param_types:
            type_in = generic_in.split(' extends ')[0]

            self.types_in.append(_replace_placeholders(type_in, placeholder_index))
            self.types_out.append(_replace_placeholders(type_out, placeholder_index))
            self.obs_types.append(_replace_placeholders(obs_type, placeholder_index))
            self.context_watcher_observable_types.append(context_watcher_observable_type)

            type_in_generic = _extract_type_generic(type_in)
            if type_in_generic is not None and _contains_placeholders(type_in_generic):
                self.generic_types.append(_replace_placeholders(type_in_generic, placeholder_index))

            extended_type_in = _extract_extended_type(generic_in)
            if extended_type_in is not None:
                self.generic_types.append(_replace_placeholders(generic_in, placeholder_index))
                extended_type_in_generic = _extract_type_generic(extended_type_in)
                if extended_type_in_generic is not None and _contains_placeholders(extended_type_in_generic):
                    self.generic_types.append(_replace_placeholders(extended_type_in_generic, placeholder_index))

            default_selector_values.append(_watchOnly_default_selector_arg(
                param_index=param_index,
                placeholder_index=placeholder_index,
                generic_in=generic_in,
                type_out=type_out
            ))
            default_selector_values_of_context.append(_watchOnly_default_selector_arg(
                param_index=param_index,
                placeholder_index=placeholder_index,
                generic_in=generic_in,
                type_out=type_out,
                of_context=True
            ))

            param_index += 1
            if _contains_both_placeholders(generic_in):
                placeholder_index += 2
            elif _contains_placeholders(generic_in):
                placeholder_index += 1

        self.generic_types_str = '<' + ', '.join([it for it in self.generic_types]) + '>' if self.generic_types else ''
        self.types_in_str = ', '.join(self.types_in)
        self.types_out_str = ', '.join(self.types_out)
        self.obs_types_str = ', '.join(self.obs_types)
        self.context_watcher_observable_types_str = ', '.join(self.context_watcher_observable_types)
        self.default_selector_values_str = ', '.join(default_selector_values)
        self.default_selector_values_of_context_str = ', '.join(default_selector_values_of_context)

    def __str__(self):
        return f'RecordTypeCombination{self.index}{self.generic_types_str} on ({self.types_in_str}) -> ({self.types_out_str})' + '\n' + '\n'.join([f'getOrCreateObservable<{i}>(...)' for i in self.obs_types]) + '\n'

    @staticmethod
    def generate(min_params=2, max_params=4, types: list[tuple[str, str, str, str]] = [
        # "on" type,                                             returned value type,     getOrCreateObservable generic type   ContextWatcherObservableType
        ('TListenable{{i}} extends Listenable',                  'TListenable{{i}}',      'TListenable{{i}}',                  'ContextWatcherObservableType.listenable'),
        ('TListenable{{i}} extends ValueListenable<T{{i + 1}}>', 'T{{i + 1}}',            'T{{i + 1}}',                        'ContextWatcherObservableType.valueListenable'),
        ('Future<T{{i}}>',                                       'AsyncSnapshot<T{{i}}>', 'T{{i}}',                            'ContextWatcherObservableType.future'),
        ('Stream<T{{i}}>',                                       'AsyncSnapshot<T{{i}}>', 'T{{i}}',                            'ContextWatcherObservableType.stream'),
    ]) -> Iterable['RecordTypeCombination']:
        index = 0
        for r in range(min_params, max_params + 1):
            for param_types in itertools.product(types, repeat=r):
                yield RecordTypeCombination(index=index, param_types=list(param_types))
                index += 1


if __name__ == '__main__':
    for combination in itertools.islice(RecordTypeCombination.generate(), 10):
        print(combination)
