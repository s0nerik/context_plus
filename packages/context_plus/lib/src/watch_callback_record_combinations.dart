/// {@template mass_watch_only_explanation}
/// Watch all observables for changes.
///
/// Whenever any observable notifies of a change, the [selector] will be
/// called with the latest values of all observables. If the [selector]
/// returns a different value, the [context] will be rebuilt.
///
/// Returns the value provided by [selector].
///
/// It is safe to call this method multiple times within the same build
/// method.
/// {@endtemplate}
///
/// {@template mass_watch_effect_explanation}
/// Watch all observables for changes.
///
/// Whenever any observable notifies of a change, the [effect] will be
/// called with the latest values of all observables, *without* rebuilding the widget.
///
/// Conditional effects are supported, but it's highly recommended to specify
/// a unique [key] for all such effects followed by the [unwatchEffect] call
/// when condition is no longer met:
/// ```dart
/// if (condition) {
///   (listenable, stream, future).watchEffect(context, key: 'effect', (_, _, _) {...});
/// } else {
///   (listenable, stream, future).unwatchEffect(context, key: 'effect');
/// }
/// ```
///
/// If [immediate] is `true`, the effect will be called upon effect
/// registration immediately. If [once] is `true`, the effect will be called
/// only once. These parameters can be combined.
///
/// [immediate] and [once] parameters require a unique [key].
/// {@endtemplate}
///
/// {@template mass_unwatch_effect_explanation}
/// Remove the effect with the given [key] from the list of effects to be
/// called when any of referenced observables notifies of a change.
/// {@endtemplate}
library;

export 'watch_callback_record_combinations/watch_callback_record_combination_1.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_2.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_3.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_4.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_5.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_6.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_7.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_8.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_9.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_10.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_11.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_12.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_13.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_14.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_15.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_16.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_17.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_18.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_19.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_20.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_21.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_22.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_23.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_24.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_25.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_26.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_27.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_28.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_29.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_30.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_31.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_32.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_33.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_34.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_35.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_36.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_37.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_38.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_39.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_40.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_41.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_42.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_43.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_44.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_45.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_46.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_47.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_48.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_49.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_50.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_51.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_52.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_53.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_54.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_55.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_56.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_57.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_58.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_59.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_60.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_61.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_62.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_63.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_64.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_65.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_66.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_67.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_68.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_69.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_70.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_71.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_72.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_73.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_74.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_75.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_76.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_77.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_78.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_79.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_80.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_81.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_82.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_83.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_84.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_85.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_86.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_87.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_88.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_89.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_90.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_91.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_92.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_93.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_94.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_95.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_96.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_97.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_98.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_99.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_100.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_101.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_102.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_103.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_104.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_105.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_106.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_107.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_108.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_109.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_110.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_111.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_112.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_113.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_114.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_115.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_116.dart';
export 'watch_callback_record_combinations/watch_callback_record_combination_117.dart';
