--Justin Jones
--COSC 3319.01 Spring 2017
--Lab 2
--
--'A' Option
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO, Ada.Integer_Text_IO; use Ada.Text_IO, Ada.Integer_Text_IO; 
with memoryManagement;

procedure main is
   type MonthName is (January, February, March, April, May, June, July, August, September, October, November, December);
   type Data is record
	   Month:	MonthName;
	   Day:	Integer range 1..31;
	   Year:	Integer range 1400..2020;
   end record;
   
   Empty : Data := (January, 1, 1400);
   
   package MonthIO is new Ada.Text_IO.Enumeration_IO(MonthName);
   use MonthIO;
   
   function "=" (X, Y : Data) return boolean is
   begin
      if X.Month = Y.Month and X.Day = Y.Day and X.Year = Y.Year then
         return true;
      else
         return false;
      end if;
   end "=";
   
   procedure aPut(X : Data) is
   begin
      if X = Empty then
         put("Empty");
      else
         put(X.Month);
         put(X.Day, width => 3);
         put(X.Year, width => 5);
      end if;
   end;
   
   --uses an unbounded string to read the line
   --then parses through the string and slices data out
   procedure aGet(input : File_Type; X : out Data) is
      line : Unbounded_String;
      i : Integer := 1;
      
   begin
      line := To_Unbounded_String(Get_Line(input));
      line := To_Unbounded_String(Get_Line(input));
      --move until end of month found
      while Slice(line, 1, i+1)(i+1) /= ' ' loop
      
         i := i + 1;
         put(i, Width => 3);
      end loop;
      --convert to month type
      X.Month := MonthName'Value(Slice(line, 1, i));
      put(X.Month);
      i := i + 1;
      X.Day := Integer'Value(Slice(line, i, i+1));
      put(X.Day);
      i := i + 4;
      X.Year := Integer'Value(Slice(line, i, i+4));
      put(X.Year);
   end;
   
   procedure bPut(X : Unbounded_String) is
   begin
      put(To_String(X));
   end;
   
   procedure bGet(input : File_Type; X : out Unbounded_String) is
   begin
      X := To_Unbounded_String(Get_Line(input));
   end;
   
   package B_Mem is new memoryManagement(Unbounded_String, bPut, bGet);
   package A_Mem is new memoryManagement(Data, aPut, aGet);
begin
   --B_Mem.makeStack("B_input.txt", To_Unbounded_String("Empty"));
   A_mem.makeStack("A_input.txt", Empty);
end main;