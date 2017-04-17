--Justin Jones
--COSC 3319.01
--TuTh 8AM
--
--B Option
--
with Ada.Text_IO, Ada.Integer_Text_IO; use Ada.Text_IO, Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

-- generic
--    type element is private;
package memoryManagement is
   type StackSpace is array(Integer range <>) of Unbounded_String;
   type growthSpace is array(Integer range <>) of Integer;
   procedure reallocate (stack : in out StackSpace; top : in out growthSpace; base : in out growthSpace; stackInfo : in out growthSpace; EqualAllocate : float; K : integer; item : in Unbounded_String);
   procedure moveStack (stack : in out StackSpace; top : in out growthSpace; base : in out growthSpace; stackInfo : in out growthSpace);
   procedure makeStack (inFile : String);
   function push (stack : in out StackSpace; top : in out growthSpace; base : in out growthSpace; stackNum : in integer; item : in Unbounded_String) return boolean;
   procedure pop (stack : in out StackSpace; top : in out growthSpace; base : in out growthSpace; stackNum : in integer);
   procedure printInfo (output : File_Type; stack : StackSpace; top : growthSpace; base : growthSpace; stackInfo : growthSpace);
end memoryManagement;