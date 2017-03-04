package body memoryManagement is

   procedure reallocate (StackSpace : array; EqualAllocate : float; K : integer) is
      AvailSpace : integer := StackSpace'Last - StackSpace'First;
      TotalInc, Sigma : integer := 0;
      j := StackSpace'Last;
      N : constant integer := StackSpace'Last;
      Insufficient_Memory : exception;
      GrowthAllocate, Alpha, Beta, Tau : float;
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
      GrowthAllocate := 1 - EqualAllocate;
      Alpha := EqualAllocate * AvailSpace / N;
      Beta := GrowthAllocate * AvailSpace / TotalInc;
      NewBase(1) := Base(1);
      for j in 2..N loop
         Tau := Sigma + Alpha + Growth(j-1) * Beta;
         NewBase(j) := NewBase(j-1) + (Top(j-1) - Base(j-1)) + float'Floor(Tau) - float'Floor(Sigma);
         Sigma := Tau;
      end loop;
      Top(K) := Top(K) - 1;
      --moveStack
      Top(K) := Top(K) + 1;
      --insert prev item
      for j in 1..arr'Length loop
         OldTop(j) := Top(j);
      end loop;
      
   procedure moveStack (arr : array(); ) is
      Delta : integer;
   begin
      for j in 2..N loop
         if NewBase(j) < Base(j) then
            Delta := Base(j) - NewBase(j);
            for l in Base(j)+1..Top(j) loop
               StackSpace(l-Delta) := StackSpace(l);
            end loop;
            Base(j) := NewBase(j);
            Top(j) := Top(j) - Delta;
         end if;
      end loop;
      
      for j in 2..N loop
         if NewBase(j) > Base(j) then
            Delta := NewBase(j) - Base(j);
            for l in Top(j)..Base(j)+1 loop
               StackSpace(l+Delta) := StackSpace(l);
            end loop;
            Base(j) := NewBase(j);
            Top(j) := Top(j) + Delta;
         end if;
      end loop;
   end moveStack;
      