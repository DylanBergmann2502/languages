// Method Invocation
const calc = {
  num: 0,
  increment() {
    console.log(this === calc); // => true
    this.num += 1;
    return this.num;
  }
};

// method invocation. this is calc
calc.increment(); // => 1
calc.increment(); // => 2

////////////////////////////////////////////////////////////////
// Object.create
const myDog = Object.create({
  sayName() {
    console.log(this === myDog); // => true
    return this.name;
  }
});

myDog.name = 'Milo';
// method invocation. this is myDog
myDog.sayName(); // => 'Milo'

////////////////////////////////////////////////////////////////
// Constructor method
class Planet {
  constructor(name) {
    this.name = name;
  }

  getName() {
    console.log(this === earth); // => true
    return this.name;
  }
}

const earth = new Planet('Earth');
// method invocation. the context is earth
earth.getName(); // => 'Earth'

////////////////////////////////////////////////////////////////
// Seperate method from object
function Pet(type, legs) {
  this.type = type;
  this.legs = legs;

  this.logInfo = function() {
    console.log(this === myCat); // => false
    console.log(`The ${this.type} has ${this.legs} legs`);
  }
}

const myCat = new Pet('Cat', 4);
// logs "The undefined has undefined legs"
// or throws a TypeError in strict mode
setTimeout(myCat.logInfo, 1000);

// Create a bound function
const boundLogInfo = myCat.logInfo.bind(myCat);
// logs "The Cat has 4 legs"
setTimeout(boundLogInfo, 1000);

// Use arrow function to bind "this"
class Pet {
  constructor(type, legs) {
    this.type = type;
    this.legs = legs;
  }

  logInfo = () => {
    console.log(this === myCat2); // => true
    console.log(`The ${this.type} has ${this.legs} legs`);
  }
}

const myCat2 = new Pet('Cat', 4);
// logs "The Cat has 4 legs"
setTimeout(myCat2.logInfo, 1000);
