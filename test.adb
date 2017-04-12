with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure test is
   type stackElement is (Blank, Burris, Zhou, Shashidhar, Shannon, Yang, Smith, Wei, Rabieh, Song, Cho, Varol, Karabiyik, Cooper, McGuire, Hope, Pray, NoHope);
   type StackSpace is array(Positive range <>) of stackElement;
   type growthSpace is array(Positive range <>) of Integer;
   package stackIO is new Ada.Text_IO.Enumeration_IO(stackElement);
   use stackIO;

   input, output : File_Type;
   upper, lower, N : integer;
   begin
   for L in reverse 2..10 loop
      put(L); New_Line;
      end loop;
      -- Open(input, in_file, "test.txt");
--       --Create(output, out_file, outFile);
--       Get(input, lower); Get(input, upper);
--       put(lower); put(upper); New_Line;
--       Get(input, N);
--       put("N = "); put(N); New_Line;
--       declare
--          stack : StackSpace (lower..upper) := (others => BLANK);
--          top : growthSpace (1..N);
--          base : growthSpace (1..N);
--          oldTop : growthSpace (1..N+1) := (others => 0);
--          M : float := Float(upper) - Float(lower) + 1.0;
--          operation : character;
--          stackNum : integer;
--          inName : stackElement;
--          Input_Error : Exception;
--          inserted : boolean;
--       begin
--          top(1) := 1;
--          put("top " & Integer'Image(1));put(" = ");put(top(1)); New_Line;
--          for i in 2..N loop
--             top(i) := Integer(Float'Floor(((Float(i) - 1.0)/Float(N)) * M)) + lower;
--             put("top " & Integer'Image(i)); put(" = "); put(top(i)); New_Line;
--             base(i) := top(i);
--          end loop;
--          while not End_of_File(input) loop
--             Get (input, operation); Get (input, stackNum);
--             put(operation); put (stackNum); New_Line;
--             
--             case(operation) is
--                when 'I' =>
--                   Get (input, inName);
--                   put(inName); New_Line;
--                   stack(top(stackNum)) := inName;
--                   top(stackNum) := top(stackNum) + 1;
--                   --inserted := push (stack, top, base, stackNum, inName);
--                   --if (not inserted) then
--                     -- reallocate (stack, top, base, oldTop, 0.15, stackNum);
--                   --end if;
--                when 'D' =>
--                   put("Deleting : "); 
--                   put(stack(top(stackNum)-1)); New_Line;
--                   top(stackNum) := top(stackNum) - 1;
--                  -- pop (stack, top, base, stackNum, output);
--                when others =>
--                   raise Input_Error;
--             end case;
--             put_line("stack: ");
--             for i in 1..N loop
--                put(Integer'Image(i) & " = "); put(stack(top(i)-1)); New_Line;
--             end loop;
--          end loop;
--       end;
end test;