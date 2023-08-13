using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Basic
{
    internal class Person
    {
        public string Name { get; set; }
        public int Age { get; set; }

        public Person(string aName, int aAge)
        {
            Name = aName;
            Age = aAge;
        }

        public void SayHello()
        {
            Console.WriteLine($"Hello, my name is {Name} and I'm {Age} years old.");
        }
    }
}
