// Array
// The length of an array is fixed and cannot be changed once it is created.
int[] numbers = new int[3] { 1, 2, 3 };
Console.WriteLine(numbers[0]); // Output: 1
Console.WriteLine(numbers[1]); // Output: 2
Console.WriteLine(numbers[2]); // Output: 3

// List
// Unlike arrays, the length of a list can be changed after it is created.
List<string> names = new List<string>();
names.Add("Alice");
names.Add("Bob");
names.Add("Charlie");
Console.WriteLine(names[1]); // Output: Bob
names.Remove("Charlie");
Console.WriteLine(names.Count); // Output: 2

// Dictionary
Dictionary<string, int> ages = new Dictionary<string, int>();
ages.Add("Alice", 25);
ages.Add("Bob", 30);
ages.Add("Charlie", 35);
Console.WriteLine(ages["Bob"]); // Output: 30
ages.Remove("Charlie");
Console.WriteLine(ages.Count); // Output: 2

// Sets
HashSet<int> numbers2 = new HashSet<int>();
numbers2.Add(1);
numbers2.Add(2);
numbers2.Add(3);
numbers2.Add(3); // Adding a duplicate value has no effect
Console.WriteLine(numbers2.Count); // Output: 3
numbers2.Remove(2);
Console.WriteLine(numbers2.Count); // Output: 2

// Try Catch Finally
try
{
    int x = 0;
    int y = 10 / x; // This will throw a DivideByZeroException
}
catch (DivideByZeroException e)
{
    Console.WriteLine("Error: " + e.Message);
}
finally
{
    Console.WriteLine();
}

// Throwing Exceptions
try
{
    string input = Console.ReadLine();
    if (string.IsNullOrEmpty(input))
    {
        throw new Exception("Input cannot be empty.");
    }
}
catch (Exception e)
{
    Console.WriteLine("Error: " + e.Message);
}

// Custom Exceptions
//public class CustomException : Exception
//{
//    public CustomException(string message) : base(message)
//    {
//    }
//}

//try
//{
//    int x = 0;
//    int y = 10 / x;
//    throw new CustomException("Custom exception message.");
//}
//catch (CustomException e)
//{
//    Console.WriteLine("Error: " + e.Message);
//}

// Reading from a File
// The StreamReader class can be used to read data from a file.
using (StreamReader reader = new StreamReader("./file.txt"))
{
    string line;
    while ((line = reader.ReadLine()) != null)
    {
        Console.WriteLine(line);
    }
}

//Writing to a File
using (StreamWriter writer = new StreamWriter("file.txt"))
{
    writer.WriteLine("Hello, world!");
}

// Appending to a File
// To append to an existing file instead of overwriting it,
// pass true as the second argument to the StreamWriter constructor:
using (StreamWriter writer = new StreamWriter("file.txt", true))
{
    writer.WriteLine("This line will be appended to the file.");
}

// Binary Files
using (BinaryWriter writer = new BinaryWriter(File.Open("file.bin", FileMode.Create)))
{
    byte[] data = { 0x00, 0x01, 0x02, 0x03 }; // 00-01-02-03
    writer.Write(data);
}

using (BinaryReader reader = new BinaryReader(File.Open("file.bin", FileMode.Open)))
{
    byte[] data = reader.ReadBytes(4);
    Console.WriteLine(BitConverter.ToString(data));
}