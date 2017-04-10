package body memoryManagement is

   procedure makeStack (inFile : String; outFile : String) is
      input, output : File_Type;
   begin
      Open(inFile, input_file, input);
      
   end makeStack;

   procedure reallocate (stack : in out StackSpace; top : in out growthSpace; EqualAllocate : float; K : integer) is
      AvailSpace : integer := stack'Last - stack'First;
      TotalInc : integer := 0;
      j : integer := stack'Last;
      N : constant integer := stack'Last;
      Insufficient_Memory : exception;
      GrowthAllocate, Alpha, Beta, Tau, Sigma : float;
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
      --if AvailSpace < (MinSpace - 1) then
      if AvailSpace < 10 then  
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
      --moveStack
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
end memoryManagement;