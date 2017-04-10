--Justin Jones
--COSC 3319.01
--TuTh 8AM
--
--B Option
--


package memoryManagement is
   type stackElements is (Burris, Zhou, Shashidhar, Shannon, Yang, Smith, Wei, Rabieh, Song, Cho, Varol, Karabiyik, Cooper, McGuire, Hope, Pray, NoHope);
   type StackSpace is array(Positive range <>) of stackElements;
   type growthSpace is array(Positive range <>) of Integer;
   procedure reallocate (stack : in out StackSpace; top : in out growthSpace; EqualAllocate : float; K : integer);
   procedure moveStack (stack : in out StackSpace; top : in out growthSpace);
   procedure makeStack (inFile : String; outFile : String);
end memoryManagement;