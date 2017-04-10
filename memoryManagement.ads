--Justin Jones
--COSC 3319.01
--TuTh 8AM
--
--B Option
--
with Ada.Text_IO, Ada.Integer_Text_IO; use Ada.Text_IO, Ada.Integer_Text_IO;

package memoryManagement is
   type stackElement is (Burris, Zhou, Shashidhar, Shannon, Yang, Smith, Wei, Rabieh, Song, Cho, Varol, Karabiyik, Cooper, McGuire, Hope, Pray, NoHope);
   type StackSpace is array(Positive range <>) of stackElement;
   type growthSpace is array(Positive range <>) of Integer;
   procedure reallocate (stack : in out StackSpace; top : in out growthSpace; EqualAllocate : float; K : integer);
   procedure moveStack (stack : in out StackSpace; top : in out growthSpace);
   procedure makeStack (inFile : String; outFile : String);
   function push (stack : in out StackSpace; top : in out growthSpace; stackNum : in integer; item : in stackElement) return boolean;
   procedure pop (stack : in out StackSpace; top : in out growthSpace; stackNum : in integer; outFile : File_Type);
   package elementIO is new Ada.Text_IO.Enumeration_IO(stackElement); use elementIO;
end memoryManagement;