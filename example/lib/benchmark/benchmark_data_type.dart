sealed class BenchmarkDataType {}

// region Streams
sealed class BenchmarkDataTypeStream extends BenchmarkDataType {}

final class BenchmarkDataTypeValueStream extends BenchmarkDataTypeStream {}
// endregion

// region Listenables
sealed class BenchmarkDataTypeListenable extends BenchmarkDataType {}

final class BenchmarkDataTypeValueListenable
    extends BenchmarkDataTypeListenable {}
// endregion

// region Signals
sealed class BenchmarkDataTypeSignal extends BenchmarkDataType {}
// endregion
