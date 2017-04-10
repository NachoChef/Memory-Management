with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure test is
   Top : array(1..10) of integer := (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
   OldTop : aliased array := Top;
   begin
      put(Top(1));

end test;