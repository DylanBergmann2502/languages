// The function counter is a closure.
// It has access to the variable count and can both
// print and increment it, but there is no other way
// for our program to access that variable.
const counterCreator = () => {
  let count = 0;
  return () => {
    console.log(count);
    count++;
  };
};

const counter = counterCreator();

counter(); // 0
counter(); // 1
counter(); // 2
counter(); // 3
