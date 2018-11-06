def call(Closure body) {
    node('host') {
        body()
    }
}
