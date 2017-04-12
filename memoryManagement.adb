package body memoryManagement is

   procedure makeStack (inFile : String; outFile : String) is
      input, output : File_Type;
      upper, lower, N, L0, M : integer;
   begin
      Open(input, in_file, inFile);
      --Create(output, out_file, outFile);
      Get(input, lower); Get(input, upper); Get(input, L0); Get(input, M); Get(input, N);
      put(lower); put(upper); put(L0); put(M); put(N); New_Line;
      put("N = "); put(N); New_Line;
      declare
         stack : StackSpace (lower..upper) := (others => Blank);
         top : growthSpace (1..N+1);
         base : growthSpace (1..N+1);
         oldTop : growthSpace (1..N+1);
         operation : character;
         stackNum : integer;
         inName : stackElement;
         Input_Error : Exception;
         inserted : boolean;
      begin
         top(1) := L0;
         for i in 2..N+1 loop
            top(i) := Integer(Float'Floor(((Float(i) - 1.0)/(Float(N))) * Float(M))) + L0;
            put("top " & Integer'Image(i)); put(" = "); put(top(i)); New_Line;
         end loop;
         base := top;
         oldTop := top;
         
         while not End_of_File(input) loop
            Get (input, operation); Get (input, stackNum);
            case(operation) is
               when 'I' =>
                  Get (input, inName);
                  inserted := push (stack, top, base, stackNum, inName);
                  if (not inserted) then
                     put_line("Reallocating...");
                     reallocate (stack, top, base, oldTop, 0.15, stackNum, inName);
                  end if;
               when 'D' =>
                 pop (stack, top, base, stackNum, output);
               when others =>
                  raise Input_Error;
            end case;
         end loop;
      end;
   end makeStack;

   procedure reallocate (stack : in out StackSpace; top : in out growthSpace; base : in out growthSpace; oldTop : in out growthSpace; EqualAllocate : float; K : integer; item : in stackElement) is
      AvailSpace : integer := base(base'Last) - base(base'First);
      TotalInc : integer := 0;
      j : integer := base'Last-1;
      N : constant integer := (top'Last - top'First);
      Insufficient_Memory : exception;
      GrowthAllocate, Alpha, Beta, Tau : float;
      Sigma : Float := 0.0;
      MinSpace : CONSTANT Integer := -5;
   begin
      while j > 0 loop
         put_line("J = " & Integer'Image(j));
         put_line("Top" & Integer'Image(j) & " is" & Integer'Image(top(j)));put_line("Base" & Integer'Image(j) & " is" & Integer'Image(base(j)));
         AvailSpace := AvailSpace - Top(j) + Base(j);
         put_line("Availspace:" & Integer'Image(AvailSpace));
         if Top(j) > OldTop(j) then --set growth
            OldTop(j+1) := Top(j) - oldTop(j);--growth
            TotalInc := TotalInc + oldTop(j+1);
         else
            oldTop(j+1) := 0;
         end if;
         j := j-1;
      end loop;
      
      for i in 2..base'Last loop
         put_line("growth:" & Integer'Image(oldtop(i)));
      end loop;
      
      if AvailSpace < (MinSpace - 1) then
         raise Insufficient_Memory;
         --terminate
      end if;
      GrowthAllocate := 1.0 - EqualAllocate;
      Alpha := EqualAllocate * (Float(AvailSpace) / Float(N));
      Beta := GrowthAllocate * (Float(AvailSpace) / Float(TotalInc));
      oldTop(1) := Base(1);
      for j in 2..N loop
         Tau := float(Sigma) + Alpha + Float(oldTop(j)) * Beta;
         OldTop(j) := OldTop(j-1) + Top(j-1) - Base(j-1) + Integer(Float'Floor(Tau)) - Integer(Float'Floor(Sigma));
         Sigma := Tau;
      end loop;
      Top(K) := Top(K) - 1;
      moveStack(stack, top, base, oldTop);
      Top(K) := Top(K) + 1;
      stack(Top(K)) := item;  --inserted
      for j in 1..base'Last-1 loop
         OldTop(j) := Top(j);
      end loop;
      
      for j in base(1)+1..base(base'Last) loop
         put("loc" & Integer'Image(j) & " is "); put((stack(j))); New_Line;      
      end loop;
      
   end reallocate;   
      
   procedure moveStack (stack : in out StackSpace; top : in out growthSpace; base : in out growthSpace; oldTop : in out growthSpace) is
      change : integer;
      N : integer := base'Last-base'First;
   begin
      for j in 2..N loop
         if oldTop(j) < Base(j) then
            change := Base(j) - oldTop(j);
            for l in Base(j)+1..Top(j) loop
               stack(l-change) := stack(l);
            end loop;
            Base(j) := oldTop(j);
            Top(j) := Top(j) - change;
         end if;
      end loop;
      
      for j in 2..N loop
         if oldTop(j) > Base(j) then
            change := oldTop(j) - Base(j);
            for L in reverse Base(j)+1..top(j) loop 
               stack(L+change) := stack(L); 
            end loop;
            Base(j) := oldTop(j);
            Top(j) := Top(j) + change;
         end if;
      end loop;
   end moveStack;
   
   function push (stack : in out StackSpace; top : in out growthSpace; base : in out growthSpace; stackNum : in integer; item : in stackElement) return boolean is
   begin
      top(stackNum) := top(stackNum) + 1;
      if (top(stackNum) > base(stackNum + 1)) then
         put("Overflow in stack"); put(Integer'Image(stackNum)); New_Line;
         return false;
      else
         put("Inserting into stack" & Integer'Image(stackNum) & " item => "); put(item); put(" at stack location" & Integer'Image(top(stackNum))); Put(".");New_Line;
         stack(top(stackNum)) := item;
         return true;
      end if;
   end push;
   
   procedure pop (stack : in out StackSpace; top : in out growthSpace; base : in out growthSpace; stackNum : in integer; outFile : File_Type) is
   begin
      if (top(stackNum) = base(stackNum)) then
         put_line("UNDERFLOW");
      else
         put("Popping stack" & Integer'Image(stackNum) & ", value <= "); put(stack(top(stackNum)-1)); New_Line;
         stack(top(stackNum)) := Blank;
         top(stackNum) := top(stackNum) - 1;
      end if;
   end pop;
   
end memoryManagement;