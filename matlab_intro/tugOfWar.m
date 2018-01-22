clear
simLen=300;
position=0;
justScored=false;
boundary=10;
team1Score(1)=0;
team2Score(1)=0;

for i=2:simLen
    if justScored
        position(i)=0;
    else
        position(i)=position(i-1)+2*randn;
    end

    justScored=false;
    
    team1Score(i)=team1Score(i-1);
    team2Score(i)=team2Score(i-1);
    if position(i)>boundary
        team1Score(i)=team1Score(i)+1;
        justScored=true;
    end
    
    if position(i)<-boundary
        team2Score(i)=team2Score(i)+1;
        justScored=true;
    end

    subplot(2,1,1);
    plot(position)
    ylabel('Ball position');

    ylim([-boundary boundary]); 
    xlim([1 simLen]);
    
    subplot(2,1,2);
    plot(1:length(team1Score),team1Score,1:length(team2Score),team2Score);
    ylabel('score');
    legend('Team 1','Team 2','Location','Northwest');
    xlim([1 simLen]);
    xlabel('Time seconds');
    
    pause(.05)
end

disp(sprintf('Final Score:'));
disp(sprintf('\tTeam 1:\t%d',team1Score(end)));
disp(sprintf('\tTeam 2:\t%d',team2Score(end)));
    
