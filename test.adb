with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure test is
   type myArray is array(Positive range <>) of integer;
   Top : myArray(1..11) := (1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11);
   OldTop : aliased myArray(2..11) := Top(1..10);
   input : integer;
   begin
   Top(3) := 7;
   loop
      Get(input);
      exit when input = 0;
      put(Top(input)); New_Line;
      put(OldTop(input)); New_Line;
   end loop;
end test;