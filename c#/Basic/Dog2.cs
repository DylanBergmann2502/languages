using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Basic
{
    internal class Dog2 : Animal2
    {
        public override string Name { get; set; }

        public override void MakeSound()
        {
            Console.WriteLine("Woof!");
        }
    }
}
