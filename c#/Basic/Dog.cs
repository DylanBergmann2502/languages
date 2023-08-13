using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Basic
{
    internal class Dog : Animal
    {
        public void Bark()
        {
            Console.WriteLine($"{Name} is barking.");
        }
    }
}
