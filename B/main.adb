with Ada.Text_IO; use Ada.Text_IO;
with memoryManagement; use memoryManagement;

procedure main is
   package myMem renames memoryManagement;
begin
   myMem.makeStack("B_input.txt");
end main;