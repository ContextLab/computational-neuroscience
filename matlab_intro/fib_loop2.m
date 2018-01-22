function FibSeq2 = HW14(SeqLength)

FibSeq = ones(1,SeqLength);
for counter = 3:1:SeqLength
    FibSeq(counter) = FibSeq(counter-2) + FibSeq(counter-1);
end
