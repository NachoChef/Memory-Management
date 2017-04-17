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
   
   procedure aGet(input : File_Type; X : out Data) is
      --initial get prevents getting ""
      temp : Unbounded_String := To_Unbounded_String(Get_Line(input));
   begin
      temp := To_Unbounded_String(Get_Line(input));
      X.Month := MonthName'Value(To_String(temp));
      Get(input, X.Day);
      Get(input, X.Year);
   end;
   
   procedure bPut(X : Unbounded_String) is
   begin
      put(To_String(X));
   end;
   
   procedure bGet(input : File_Type; X : out Unbounded_String) is
   begin
      --first get prevents getting ""
      X := To_Unbounded_String(Get_Line(input));
      X := To_Unbounded_String(Get_Line(input));
   end;
   
   package B_Mem is new memoryManagement(Unbounded_String, bPut, bGet);
   package A_Mem is new memoryManagement(Data, aPut, aGet);
begin
   --B_Mem.makeStack("B_input.txt", To_Unbounded_String("Empty"));
   A_mem.makeStack("A_input.txt", Empty);
end main;