--Justin Jones
--COSC 3319.01 Spring 2017
--Lab 2
--
--'A' Option
with Ada.Text_IO, Ada.Integer_Text_IO; use Ada.Text_IO, Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

generic
    type element is private;
    with procedure myPut(X : element);
    with procedure myGet(input : File_Type; X : out element);
package memoryManagement is
   type StackSpace is array(Integer range <>) of element;
   type growthSpace is array(Integer range <>) of Integer;
   procedure reallocate (stack : in out StackSpace; top : in out growthSpace; base : in out growthSpace; stackInfo : in out growthSpace; EqualAllocate : float; K : integer; item : in element);
   procedure moveStack (stack : in out StackSpace; top : in out growthSpace; base : in out growthSpace; stackInfo : in out growthSpace);
   procedure makeStack (inFile : String; Empty : element);
   function push (stack : in out StackSpace; top : in out growthSpace; base : in growthSpace; stackNum : in integer; item : in element) return boolean;
   procedure pop (stack : in out StackSpace; top : in out growthSpace; base : in growthSpace; stackNum : in integer);
   procedure printInfo (stack : StackSpace; top : growthSpace; base : growthSpace; stackInfo : growthSpace);
end memoryManagement;