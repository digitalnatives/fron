var SynteticEvent = function(target, data){
  this.immediatePropagate = true;
  this.defaultPrevented = false;
  this.propagate = true;
  this.target = target;
  for (var key in data) {
    this[key] = data[key];
  }
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

window.SynteticEvent = SynteticEvent;
