using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Basic
{
    internal class BankAccount
    {
        private double balance;

        public void Deposit(double amount)
        {
            balance += amount;
        }

        public void Withdraw(double amount)
        {
            if (balance >= amount)
            {
                balance -= amount;
            }
        }

        public double GetBalance()
        {
            return balance;
        }
    }
}
