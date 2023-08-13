using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Basic
{
    internal class Book
    {
        public string title;
        public string author;
        public int pages;

        public Book(string aTitle, string aAuthor, int aPage)
        {
            title = aTitle;
            author = aAuthor;
            pages = aPage;
        }
    }
}
