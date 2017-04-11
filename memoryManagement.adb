package body memoryManagement is

   procedure makeStack (inFile : String; outFile : String) is
      input, output : File_Type;
      upper, lower, N : integer;
   begin
      Open(input, in_file, inFile);
      Create(output, out_file, outFile);
      Get(input, lower); Get(input, upper);
      Get(input, N);
      declare
         stack : StackSpace (lower..upper);
         top : growthSpace (1..N);
         base : growthSpace (1..N);
         oldTop : growthSpace (1..N+1);
         newBase : aliased growthSpace (1..N) := oldTop;
         growth : aliased growthSpace (2..N+1) := oldTop(1..N);
         M : float := Float(upper - lower + 1);
         operation : character;
         stackNum : integer;
         inName : stackElement;
         Input_Error : Exception;
         inserted : boolean;
      begin
         for i in 1..N loop
            top(i) := Integer(Float'Floor((Float(i) - 1.0/Float(N)) * M)) + lower + 1;
            base(i) := top(i);
         end loop;
         while not End_of_File(input) loop
            Get (input, operation); Get (input, stackNum);
            case(operation) is
               when 'I' =>
                  Get (input, inName);
                  inserted := push (stack, top, stackNum, inName);
                  if (not inserted) then
                     reallocate (stack, top, 0.15, stackNum);
                  end if;
               when 'D' =>
                  pop (stack, top, stackNum, output);
               when others =>
                  raise Input_Error;
            end case;
         end loop;
      end;
   end makeStack;

   procedure reallocate (stack : in out StackSpace; top : in out growthSpace; base : in out growthSpace; oldTop : in out growthSpace; EqualAllocate : float; K : integer) is
      AvailSpace : integer := stack'Last - stack'First;
      TotalInc : integer := 0;
      j : integer := stack'Last;
      N : constant integer := (top'Last - top'First);
      Insufficient_Memory : exception;
      GrowthAllocate, Alpha, Beta, Tau, Sigma : float;
      MinSpace : CONSTANT Integer := 7;
      newBase : aliased growthSpace (1..N) := oldTop;
      Growth : aliased growthSpace (2..N) := oldTop(1..N-1);
   begin
      while j > 0 loop
         AvailSpace := AvailSpace - (Top(j) - Base(j));
         if Top(j) > OldTop(j) then
            Growth(j) := Top(j) - OldTop(j);
            TotalInc := TotalInc + Growth(j);
         else
            Growth(j) := 0;
         end if;
         j := j-1;
      end loop;
      if AvailSpace < (MinSpace - 1) then
         raise Insufficient_Memory;
         --terminate
      end if;
      GrowthAllocate := 1.0 - EqualAllocate;
      Alpha := EqualAllocate * Float(AvailSpace) / Float(N);
      Beta := GrowthAllocate * Float(AvailSpace) / Float(TotalInc);
      NewBase(1) := Base(1);
      for j in 2..N loop
         Tau := float(Sigma) + Alpha + Float(Growth(j-1) * Beta);
         NewBase(j) := NewBase(j-1) + (Top(j-1) - Base(j-1)) + float'Floor(Tau) - float'Floor(Sigma);
         Sigma := Tau;
      end loop;
      Top(K) := Top(K) - 1;
      moveStack(stack, top);
      Top(K) := Top(K) + 1;
      --insert prev item
      for j in 1..stack'Length loop
         OldTop(j) := Top(j);
      end loop;
   end reallocate;   
      
   procedure moveStack (stack : in out StackSpace; top : in out growthSpace) is
      change : integer;
      N : integer := stack'Last;
   begin
      for j in 2..N loop
         if NewBase(j) < Base(j) then
            change := Base(j) - NewBase(j);
            for l in Base(j)+1..Top(j) loop
               stack(l-change) := stack(l);
            end loop;
            Base(j) := NewBase(j);
            Top(j) := Top(j) - change;
         end if;
      end loop;
      
      for j in 2..N loop
         if NewBase(j) > Base(j) then
            change := NewBase(j) - Base(j);
            for l in Top(j)..Base(j)+1 loop
               stack(l+change) := stack(l);
            end loop;
            Base(j) := NewBase(j);
            Top(j) := Top(j) + change;
         end if;
      end loop;
   end moveStack;
   
   function push (stack : in out StackSpace; top : in out growthSpace; stackNum : in integer; item : in stackElement) return boolean is
   begin
      if (stack(top(stackNum)) > stack(base(stackNum + 1))) then
         return false;
      else
         stack(top(stackNum)) := item;
         top(stackNum) := top(stackNum) + 1;
         return true;
      end if;
   end push;
   
   procedure pop (stack : in out StackSpace; top : in out growthSpace; base : in out growthSpace; stackNum : in integer; outFile : File_Type) is
   begin
      if (stack(base(stackNum)) = stack(base(stackNum))) then
         null; --underflow
      else
         put(outFile, "Popping stack " & Integer'Image(stackNum) & ", value := "); put(outFile, stack(top(stackNum))); New_Line;
         top(stackNum) := top(stackNum) - 1;
      end if;
   end pop;
   
end memoryManagement;