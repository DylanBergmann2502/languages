let User = class {
  sayHi() {
    console.log("Hello");
  }
};

////////////////////////////////////////////////////////////////////////
// "Named Class Expression"
// (no such term in the spec, but that's similar to Named Function Expression)
let User2 = class MyClass {
  sayHi() {
    console.log(MyClass); // MyClass name is visible only inside the class
  }
};

new User().sayHi(); // works, shows MyClass definition

// console.log(MyClass); // error, MyClass name isn't visible outside of the class

////////////////////////////////////////////////////////////////////////
function makeClass(phrase) {
  // declare a class and return it
  return class {
    sayHi() {
      console.log(phrase);
    }
  };
}

// Create a new class
let User3 = makeClass("Hello3");

new User3().sayHi(); // Hello3

////////////////////////////////////////////////////////////////////////
// Class + Getter/Setter
class User4 {

  constructor(name) {
    // invokes the setter
    this.name = name;
  }

  get name() {
    return this._name;
  }

  set name(value) {
    if (value.length < 4) {
      console.log("Name is too short.");
      return;
    }
    this._name = value;
  }

}

let user = new User4("John");
console.log(user.name); // John

user = new User("112"); // Name is too short.
console.log(user.name); // undefined

/////////////////////////////////////////////////////////////////
// Bound methods
// Method 1: Pass a wrapper-function
class Button1 {
  constructor(value) {
    this.value = value;
  }

  click() {
    console.log(this.value);
  }
}

let button1 = new Button1("hello");

setTimeout(button1.click, 1000); // undefined
setTimeout(() => button1.click(), 1000); // hello

// Method 2: Bind the method to object, e.g. in the constructor.
class Button2 {
  constructor(value) {
    this.value = value;
  }
  click = () => {
    console.log(this.value);
  }
}

let button2 = new Button2("hello");

setTimeout(button2.click, 1000); // hello
