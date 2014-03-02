// Taken from http://stackoverflow.com/questions/3037008/assembly-version-from-command-line

using System;
using System.IO;
using System.Reflection;

class Program {
  public static void Main(string[] args) {
    foreach (string arg in args) {
      try {
        string path = Path.GetFullPath(arg);
        var assembly = Assembly.LoadFile(path);
        Console.Out.WriteLine(assembly.GetName().FullName);
      } catch (Exception exception) {
        Console.Out.WriteLine(string.Format("{0}: {1}", arg, exception.Message));
      }
    }
  }
}
