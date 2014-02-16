function lazyProduct(sets, holla) {
    var setLength = sets.length;
    function helper(array_current, set_index) {
        if (++set_index >= setLength) {
            holla.apply(null, array_current);
        } else {
            var array_next = sets[set_index];
            for (var i=0; i<array_next.length; i++) {
                helper(array_current.concat(array_next[i]), set_index);
            }
        }
    }
    helper([], -1);
}