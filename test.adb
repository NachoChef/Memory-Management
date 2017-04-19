--with hashB; 
with Ada.Text_IO, direct_io; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Unchecked_Conversion;
with memoryManagement;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
procedure test is

type StackSpace is array(Integer range <>) of Unbounded_String;
   type growthSpace is array(Integer range <>) of Integer;
   subtype slice is String(1..2);
   type Unsigned_64 is mod 2**64;
   function str2Long is new Ada.Unchecked_Conversion(slice, Long_integer);
   function str2Uns is new Ada.Unchecked_Conversion(slice, Unsigned_64);
   function long2Int is new Ada.Unchecked_Conversion(Long_integer, Integer);
   function uns2Int is new Ada.Unchecked_Conversion(Unsigned_64, Integer);
   package ASU renames Ada.Strings.Unbounded;
   test : ASU.Unbounded_String;
   file : File_Type;
   stack : StackSpace (1..5) := (others => To_Unbounded_String("Empty"));
         top : growthSpace (1..5) := (others => 1);
         base : growthSpace (1..5);
         stackInfo : growthSpace (1..5); --growth = stackInfo(J+1)
         operation : character;
         stackNum : integer;
         inName : Unbounded_String;
         Input_Error : Exception;
         inserted : boolean;     
         
   function push (stack : in out StackSpace; item : in Unbounded_String) return boolean is
   begin
      
      put("Inserting into stack" & Integer'Image(1) & " item => "); put(To_String(item)); put(" at stack location" & Integer'Image(2)); Put(".");New_Line;
         stack(2) := item;
         return true;
      
   end push;
   str : String(1..4);
begin
   put(Integer'Value("01"));
   -- put_line("Part A:");
   --hashB.mainMem("Words200D16.txt", 128, 0.40, hashB.linear, hashB.mine);
--    
--    put_line("Part B:");
--    hashB.mainMem("Words200D16.txt", 128, 0.87, hashB.linear);
   
   -- put_line("Part C:");
--    hashB.mainMem("Words200D16.txt", 128, 0.40, hashB.random);
--    hashB.mainMem("Words200D16.txt", 128, 0.87, hashB.random);
   -- loop
--       get(str);
--       exit when str(1) = '0';
--       put_line(Integer'Image(hashB.myKey(str, 128)));
--    end loop;
end test;

