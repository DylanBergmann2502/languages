// Number
a = Number("-12");
console.log(a.isNaN);

console.log(a, a.toString())

//Math
b = Math.abs(a)
console.log(b)

//Date
c = Date.now()
console.log(c)

const today = new Date()
const birthday = new Date("December 17, 1995 03:24:00"); // DISCOURAGED: may not work in all runtimes
const birthday2 = new Date("1995-12-17T03:24:00"); // This is ISO8601-compliant and will work reliably
const birthday3 = new Date(1995, 11, 17); // the month is 0-indexed
const birthday4 = new Date(1995, 11, 17, 3, 24, 0);
const birthday5 = new Date(628021800000); // passing epoch timestamp
console.log(today);

