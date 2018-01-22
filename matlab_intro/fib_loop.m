function FibSeq = HW14(SeqLength)

FibSeq = [1 1]
for counter = 3:1:SeqLength
    FibSeq = [FibSeq (FibSeq(counter-2) + FibSeq(counter-1))];
end
