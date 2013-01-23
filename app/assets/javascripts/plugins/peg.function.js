function peg_flatten(array) {
    var flat = [];
    for (var i = 0, l = array.length; i < l; i++){
        var type = Object.prototype.toString.call(array[i]).split(' ').pop().split(']').shift().toLowerCase();
        if (type) { flat = flat.concat(/^(array|collection|arguments|object)$/.test(type) ? peg_flatten(array[i]) : array[i]); }
    }
    return flat;
}
function peg_cast_num(a) {
  return a.replace(/[０１２３４５６７８９]/g
    , function(a){
      var b = "０１２３４５６７８９".indexOf(a);
      return (b !== -1)? b:a;
    }
  );
}
