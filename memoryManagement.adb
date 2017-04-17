--Justin Jones
--COSC 3319.01 Spring 2017
--Lab 2
--
--'A' Option
package body memoryManagement is

   procedure makeStack (inFile : String; Empty : element) is
      input : File_Type;
      upper, lower, N, L0, M : integer;
   begin
      Open(input, in_file, inFile);
      Get(input, lower); Get(input, upper); Get(input, L0); 
      Get(input, M); Get(input, N);
      Set_Col(10); put("LB"); 
      Set_Col(21); put("UB"); 
      Set_Col(32); put("L0");
      Set_Col(44); put("M");
      Set_Col(55); put("N"); New_Line;
      put(lower); put(upper); put(L0); put(M); put(N); New_Line;
      declare
         stack : StackSpace (lower..upper) := (others => Empty);
         top : growthSpace (1..N);
         base : growthSpace (1..N+1);
         stackInfo : growthSpace (1..N+1); --growth = stackInfo(J+1)
         operation : character;
         stackNum : integer;
         inName : element;
         Input_Error : Exception;
         inserted : boolean;
      begin
         top(1) := L0;
         base(1) := L0;
         stackInfo(1) := L0;
         for i in 2..N loop
            top(i) := Integer(Float'Floor(((Float(i) - 1.0)/(Float(N))) 
                        * Float(M-L0))) + L0;
            base(i) := top(i);
            stackInfo(i) := top(i);
         end loop;
         base(N+1) := M;
         printInfo (stack, top, base, stackInfo);
         while not End_of_File(input) loop
            Get(input, operation); Get(input, stackNum);
            case(operation) is
               when 'I' =>
                  myGet(input, inName);
                  inserted := push (stack, top, base, stackNum, inName);
                  if (not inserted) then
                     reallocate(stack, top, base, stackInfo, 0.15, stackNum, inName);
                  end if;
               when 'D' =>
                 pop (stack, top, base, stackNum);
               when others =>
                  raise Input_Error;
            end case;
         end loop;
      end;
   end makeStack;

   procedure reallocate (stack : in out StackSpace; top : in out growthSpace; 
                        base : in out growthSpace; stackInfo : in out growthSpace;
                        EqualAllocate : float; K : integer; item : in element) is
      AvailSpace : integer := base(base'Last) - base(base'First);
      TotalInc : integer := 0;
      j : integer := base'Last-1; --# stacks
      N : constant integer := (base'Last - base'First);
      Insufficient_Memory : exception;
      GrowthAllocate, Alpha, Beta, Tau : float;
      Sigma : Float := 0.0;
      MinSpace : Integer := Integer(Float'Ceiling(0.05 * Float(AvailSpace)));
   begin
      New_Line;
      put_line("Current values:");
      printInfo (stack, top, base, stackInfo);
      
      New_Line;
      put_line("Reallocating...");
      New_Line;
      
      while j > 0 loop
         AvailSpace := AvailSpace - Top(j) + Base(j);
         if Top(j) > stackInfo(j) then --set growth
            stackInfo(j+1) := Top(j) - stackInfo(j);--growth
            TotalInc := TotalInc + stackInfo(j+1);
         else
            stackInfo(j+1) := 0;
         end if;
         j := j-1;
      end loop;
            
      if AvailSpace < (MinSpace - 1) then
         put("Out of memory! Terminating...");
         raise Insufficient_Memory;
         --terminate
      end if;
      GrowthAllocate := 1.0 - EqualAllocate;
      Alpha := EqualAllocate * (Float(AvailSpace) / Float(N));
      Beta := GrowthAllocate * (Float(AvailSpace) / Float(TotalInc));
      stackInfo(1) := Base(1);
      for j in 2..N loop
         Tau := float(Sigma) + Alpha + Float(stackInfo(j)) * Beta;
         stackInfo(j) := stackInfo(j-1) + Top(j-1) - Base(j-1)  
                         + Integer(Float'Floor(Tau))
                         - Integer(Float'Floor(Sigma));
         Sigma := Tau;
      end loop;
      Top(K) := Top(K) - 1;
      moveStack(stack, top, base, stackInfo);
      Top(K) := Top(K) + 1;
      stack(Top(K)) := item;  --inserted
      for j in 1..base'Last-1 loop
         stackInfo(j) := Top(j);
      end loop;
      
      put_line("New values:");
      printInfo (stack, top, base, stackInfo);
   end reallocate;   
      
   procedure moveStack (stack : in out StackSpace; top : in out growthSpace; 
                        base : in out growthSpace; stackInfo : in out growthSpace) is
      change : integer;
      N : integer := base'Last-base'First;
   begin
      for j in 2..N loop
         if stackInfo(j) < Base(j) then
            change := Base(j) - stackInfo(j);
            for l in Base(j)+1..Top(j) loop
               stack(l-change) := stack(l);
               stack(l) := stack(base(1));
            end loop;
            Base(j) := stackInfo(j);
            Top(j) := Top(j) - change;
         end if;
      end loop;
      
      for j in reverse 2..N loop
         if stackInfo(j) > Base(j) then
            change := stackInfo(j) - Base(j);
            for L in reverse Base(j)+1..top(j) loop 
               stack(L+change) := stack(L);
               stack(l) := stack(base(1)); 
            end loop;
            Base(j) := stackInfo(j);
            Top(j) := Top(j) + change;
         end if;
      end loop;
   end moveStack;
   
   function push (stack : in out StackSpace; top : in out growthSpace;
                  base : in growthSpace; stackNum : in integer; 
                  item : in element) return boolean is
   begin
      top(stackNum) := top(stackNum) + 1;
      if top(stackNum) > base(stackNum + 1) then
         put("Inserting into stack" & Integer'Image(stackNum) & " item => "); 
         myPut(item); put(" has caused overflow!");New_Line;
         return false;
      else
         put("Inserting into stack" & Integer'Image(stackNum) & " item => "); 
         myPut(item); put(" at stack location" & Integer'Image(top(stackNum))); 
         put_line(".");
         stack(top(stackNum)) := item;
         return true;
      end if;
   end push;
   
   procedure pop (stack : in out StackSpace; top : in out growthSpace;
                  base : in growthSpace; stackNum : in integer) is
   begin
      if (top(stackNum) = base(stackNum)) then
         put_line("Delete resulted in underflow in stack" & Integer'Image(stackNum));
         put_line("Continuing...");
      else
         put("Popping stack" & Integer'Image(stackNum) & ", value <= "); 
         myPut(stack(top(stackNum))); New_Line;
         --Base(1) will always index an 'empty' location
         stack(top(stackNum)) := stack(base(1));
         top(stackNum) := top(stackNum) - 1;
      end if;
   end pop;
   
   procedure printInfo (stack : StackSpace; top : growthSpace; base : growthSpace; 
                        stackInfo : growthSpace) is
   begin
      Set_Col(15); put("BASE");
      Set_Col(30); put("TOP");
      Set_Col(39); put("OLDTOP");
      New_Line;
      for i in base'First..base'Last-1 loop
         put("Stack" & Integer'Image(i)); 
         put(base(i));
         put(Character'Val(9));
         put(top(i));
         put(Character'Val(9));
         put(stackInfo(i));
         New_Line;
      end loop;
      New_Line;
      for j in base(1)..base(base'Last) loop
         put("loc" & Integer'Image(j) & " is "); myPut(stack(j)); New_Line;      
      end loop;
      New_Line;
   end printInfo;
   
end memoryManagement;