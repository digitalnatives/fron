window.SynteticEvent = function(target, data){
  this.immediatePropagate = true;
  this.defaultPrevented = false;
  this.propagate = true;
  this.target = target;
  this.data = data;
};

SynteticEvent.prototype.stopImmediatePropagation = function(){
  this.immediatePropagate = false;
};

SynteticEvent.prototype.stopPropagation = function(){
  this.propagate = false;
};

SynteticEvent.prototype.preventDefault = function(){
  this.defaultPrevented = true;
};
