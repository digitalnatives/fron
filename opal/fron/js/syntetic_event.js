SynteticEvent = function(target, data){
  this.target = target
  this.defaultPrevented = false
  this.immediatePropagate = true
  this.propagate = true
  this.data = data
}
SynteticEvent.prototype.stopImmediatePropagation = function(){
  this.immediatePropagate = false
}
SynteticEvent.prototype.stopPropagation = function(){
  this.propagate = false
}
SynteticEvent.prototype.preventDefault = function(){
  this.defaultPrevented = true
}
