// Scope A: Global scope out here
var myFunction = function () {
  // Scope B: Local scope in here
};

////////////////////////////////////////////////////////////////
var myFunction = function () {
  var name = 'Todd';
  console.log(name); // Todd
};
// Uncaught ReferenceError: name is not defined
console.log(name);

////////////////////////////////////////////////////////////////
var name = 'Todd';
var scope1 = function () {
  // name is available here
  var scope2 = function () {
    // name is available here too
    var scope3 = function () {
      // name is also available here!
    };
  };
};

////////////////////////////////////////////////////////////////
// name = undefined
var scope1 = function () {
  // name = undefined
  var scope2 = function () {
    // name = undefined
    var scope3 = function () {
      var name = 'Todd'; // locally scoped
    };
  };
};

////////////////////////////////////////////////////////////////
// The "closure" concept we’ve used here makes our scope
// inside sayHello inaccessible to the public scope.
// Calling the function alone will do nothing
// as it returns a function
var sayHello = function (name) {
  var text = 'Hello, ' + name;
  return function () {
    console.log(text);
  };
};

sayHello('Todd'); // nothing happens, no errors, just silence...

var helloTodd = sayHello('Todd');
helloTodd(); // will call the closure and log 'Hello, Todd'

sayHello('Bob')(); // calls the returned function without assignment
