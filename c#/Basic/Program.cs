// See https://aka.ms/new-console-template for more information
using Basic;

Console.WriteLine("Hello, World!");
Console.ReadLine();

// Variable Data Types
int myNumber = 10;
float myFloat = 3.14f;
double myDouble = 1.23456789;
bool myBool = true;
string myString = "Hello, world! This is Tech with Christian :)";

Console.WriteLine($"My string is {myString}");

// Arithmetic Operators
int a = 10;
int b = 5;

int sum = a + b;    // addition
int difference = a - b;    // subtraction
int product = a * b;    // multiplication
int quotient = a / b;    // division
int remainder = a % b;    // modulus (returns the remainder of a division operation)

// Comparison Operators
bool isEqual = a == b;    // equal to
bool isNotEqual = a != b;    // not equal to
bool isGreater = a > b;    // greater than
bool isLess = a < b;    // less than
bool isGreaterOrEqual = a >= b;    // greater than or equal to
bool isLessOrEqual = a <= b;    // less than or equal to

// Logical Operators
bool c = true;
bool d = false;

bool andResult = c && d;    // logical AND
bool orResult = c || d;    // logical OR
bool notResult = !c;    // logical NOT

// Assignment Operators
a += b;    // equivalent to a = a + b
a -= b;    // equivalent to a = a - b
a *= b;    // equivalent to a = a * b
a /= b;    // equivalent to a = a / b
a %= b;    // equivalent to a = a % b

// Control Flow Statements
// int myNumber = 10;

if (myNumber < 5)
{
    Console.WriteLine("The number is less than 5");
}
else if (myNumber > 15)
{
    Console.WriteLine("The number is greater than 15");
}
else
{
    Console.WriteLine("The number is between 5 and 15");
}

for (int n = 0; n < 10; n++)
{
    Console.WriteLine("The value of n is: " + n);
}

// Functions
int AddNumbers(int a, int b)
{
    return a + b;
}

int result = AddNumbers(10, 5);
Console.WriteLine("The result is: " + result);

// Classes and Objects
//class Person
//{
//    public string Name { get; set; }
//    public int Age { get; set; }

//    public Person(string aName, int aAge)
//    {
//        Name = aName;
//        Age = aAge;
//    }

//    public void SayHello()
//    {
//        Console.WriteLine($"Hello, my name is {Name} and I'm {Age} years old.");
//    }
//}

Person john = new Person("John", 30);
//john.Name = "John";
//john.Age = 30;
john.SayHello(); // Output: Hello, my name is John and I'm 30 years old.

// Inheritance
//class Animal
//{
//    public string Name { get; set; }

//    public void Eat()
//    {
//        Console.WriteLine($"{Name} is eating.");
//    }
//}

//class Dog : Animal
//{
//    public void Bark()
//    {
//        Console.WriteLine($"{Name} is barking.");
//    }
//}

Dog fido = new Dog();
fido.Name = "Fido";
fido.Eat(); // Output: Fido is eating.
fido.Bark(); // Output: Fido is barking.

// Polymorphism
//class Shape
//{
//    public virtual void Draw()
//    {
//        Console.WriteLine("Drawing a shape.");
//    }
//}

//class Circle : Shape
//{
//    public override void Draw()
//    {
//        Console.WriteLine("Drawing a circle.");
//    }
//}

//class Square : Shape
//{
//    public override void Draw()
//    {
//        Console.WriteLine("Drawing a square.");
//    }
//}

Shape shape1 = new Circle();
shape1.Draw(); // Output: Drawing a circle.

Shape shape2 = new Square();
shape2.Draw(); // Output: Drawing a square.

// Abstraction
//abstract class Animal
//{
//    public abstract string Name { get; set; }
//    public abstract void MakeSound();
//}

//class Dog : Animal
//{
//    public override string Name { get; set; }

//    public override void MakeSound()
//    {
//        Console.WriteLine("Woof!");
//    }
//}

Animal2 dog2 = new Dog2();
dog2.Name = "Fido";
dog2.MakeSound(); // Output: Woof!

// Encapsulation
//class BankAccount
//{
//    private double balance;

//    public void Deposit(double amount)
//    {
//        balance += amount;
//    }

//    public void Withdraw(double amount)
//    {
//        if (balance >= amount)
//        {
//            balance -= amount;
//        }
//    }

//    public double GetBalance()
//    {
//        return balance;
//    }
//}

BankAccount account = new BankAccount();
account.Deposit(1000);
account.Withdraw(500);
double balance = account.GetBalance(); // balance is 500
