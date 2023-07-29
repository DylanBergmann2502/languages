// Function Invocation
function sum(a, b) {
   console.log(this === window); // => true
  this.myNumber = 20; // add 'myNumber' property to global object
  return a + b;
}
// sum() is invoked as a function
// this in sum() is a global object (window)
sum(15, 16);     // => 31
window.myNumber; // => 20

////////////////////////////////////////////////////////////////
// Strict mode
function multiply(a, b) {
  'use strict'; // enable the strict mode
  console.log(this === undefined); // => true
  return a * b;
}
// multiply() function invocation with strict mode enabled
// this in multiply() is undefined
multiply(2, 5); // => 10

////////////////////////////////////////////////////////////////
// Inner function
const numbers = {
  numberA: 5,
  numberB: 10,

  sum: function() {
    console.log(this === numbers); // => true

    function calculate() {
      // this is window or undefined in strict mode
      console.log(this === numbers); // => false
      return this.numberA + this.numberB;
    }

    return calculate();
  }
};

////////////////////////////////////////////////////////////////
numbers.sum(); // => NaN or throws TypeError in strict mode

const numbers2 = {
  numberA: 5,
  numberB: 10,
  sum: function() {
    console.log(this === numbers2); // => true

    function calculate() {
      console.log(this === numbers2); // => true
      return this.numberA + this.numberB;
    }

    // use .call() method to modify the context
    return calculate.call(this);
  }
};
numbers2.sum(); // => 15

////////////////////////////////////////////////////////////////
const numbers3 = {
  numberA: 5,
  numberB: 10,
  sum: function() {
    console.log(this === numbers3); // => true

    const calculate = () => {
      console.log(this === numbers3); // => true
      return this.numberA + this.numberB;
    }

    return calculate();
  }
};

numbers3.sum(); // => 15

