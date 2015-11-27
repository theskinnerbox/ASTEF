function [ gazePoints, fixIndicator, fixStats ] = tobii_gaze2fix( gazedataleft, gazedataright, timestamp, method, lastTsFile )
%TOBIIIMPORT Import data from Tobii format
%   Tobii formatted data is converted into ASTEF format
% Input:
%   gazedataleft: 1xm vector from Tobii read with left gaze data
%   gazedataright: 1xm vector from Tobii read with right gaze data
%   timestamp: 1xm vector from Tobii read with timestamps
%   method: select the method to compute fixations. Could be 'tobii' or 'astef'
% Output:
%   gazePoint: 2xm matrix with x y coordinates of gaze points
%   fixIndicator: indexes of gazePoint that are fixations
%   fixStats: 4xm matrix with fixations X,Y average centre coordinates,
%   duration and timestamp

% NOTE: this implementation is from "Tobii®Toolbox for Matlab
% Product Description & User Guide" Version 1.1, released on 02.07.2010.
% Original ASATEF implementation use the algorithm in FixId.cs
% (ASTEF1.0beta). See the end of current file for an excerpt.

if nargin < 3
    error('fixImport:argChk','Gaze2Fix: Not enough input arguments');
end

if nargin < 4
    method = 'tobii';
end

if nargin < 5
    lastTsFile = [];
end

firstTimestamp = getFirstTimestamp(lastTsFile);
setFirstTimestamp(timestamp(end),lastTsFile);
gazedataleft = gazedataleft(timestamp>firstTimestamp,:);
gazedataright = gazedataright(timestamp>firstTimestamp,:);
timestamp = timestamp(timestamp>firstTimestamp);

screenSiz = [1024 0; 0 768];

% START DEBUG
if 0
    [ gazePointsT, fixIndicatorT, fixStatsT ] = tobii( gazedataleft, gazedataright, timestamp ); %#ok<UNRCH>
    [ gazePointsA, fixIndicatorA, fixStatsA ] = astef( gazedataleft, gazedataright, timestamp );
    
    figT = figure();
    plot(fixStatsT(:,1),fixStatsT(:,2),'o');
    nT = size(fixStatsT,1);
    set(figT,'Name',['TOBII: ' num2str(nT) ' fix']);
    xlim([0 1]);
    ylim([0 1]);
    
    figA = figure();
    plot(fixStatsA(:,1),fixStatsA(:,2),'or');
    nA = size(fixStatsA,1)
    set(figA,'Name',['ASTEF: ' num2str(nA) ' fix']);
    xlim([0 1024]);
    ylim([0 768]);
    % xlim([0 1]);
    % ylim([0 1]);
    
    return
    % save('fixData.mat','gazedataleft','gazedataright','timestamp');
    % disp('Saved: comparison.');
end
% END DEBUG

if strcmp(method,'tobii') || strcmp(method,'t')
    [ gazePoints, fixIndicator, fixStats ] = tobii( gazedataleft, gazedataright, timestamp );
elseif strcmp(method,'astef') || strcmp(method,'a')
    [ gazePoints, fixIndicator, fixStats ] = astef( gazedataleft, gazedataright, timestamp );
else
    error('fixImport:argChk','Tobii gaze2fix: unknown method');
end



    function [ gazePoints, fixIndicator, fixStats ] = tobii( gazedataleft, gazedataright, timestamp )
        GazeData = ParseGazeData(gazedataleft, gazedataright);
        
        %trackstarttime = timestamp(1);
        nPoints = size(gazedataleft,1);
        %calculate the average x and y gaze coordinates from the left and right eye
        %positions from Tobii
        gazePoints(:,1) = 0.5 * (GazeData.left_gaze_point_2d.x + GazeData.right_gaze_point_2d.x); % Gaze Point X
        gazePoints(:,2) = 0.5 * (GazeData.left_gaze_point_2d.y + GazeData.right_gaze_point_2d.y); % Gaze Point Y
        fixIndicator = zeros(nPoints,1);
        
        % Check data validity
        %         nDelta = size(timestamp,1)-1;
        %         sampleHz = zeros(nDelta,1);
        %         figure('Name','Tobii hz');
        %         for i = 1:nDelta;
        %             sampleHz(i) = 1./(timestamp(i+1)-timestamp(i));
        %         end
        %         hold on;
        %         plot(sampleHz);
        %         plot(mean(sampleHz)*ones(size(sampleHz)),'r');
        %         xlabel('sample');
        %         ylabel('hz');
        
        % Tune these values to control fixations
        % ASTEF: iFixationRadius = 25px; iMinFixDuration = 100ms;
        
        %original
%                 fixationduration = 8; %100/(1000/120) i.e. 100ms window/duration of a single row on the 120Hz file, use 6 for 60Hz (binocular)
%                 fixationhrange = 0.029; % 57cm*tand(1)/34cm, i.e.  +/- 0.5 degree as a percentage of the screen size for standard T120 monitor (17'') with 57cm viewing distance
%                 fixationvrange = 0.037; % 57cm*tand(1)/27cm,+/- 0.5 degree as a percentage of the screen size for standard T120 monitor (17'') with 57cm viewing distance
        
        
        %1
                fixationduration = 4; % 100ms/(1000/40Hz)
                fixationhrange = 0.0488; % 50px/1024px, i.e. +/- 25px
                fixationvrange = 0.0651; % 50px/768px, i.e. +/- 25px
        
        %2
%                 fixationduration = 4; % 100ms/(1000/40Hz)
%                 fixationhrange = 0.039;
%                 fixationvrange = 0.051;
        
        %3
%         fixationduration = 6; % 100ms/(1000/40Hz)
%         fixationhrange = 0.039;
%         fixationvrange = 0.051;
        
        
        
        %fixation(1,1:6) =0;
        
        %set the fixation indicator as follows:
        %if the gaze position (x,y) over a rolling 100ms window does not change by more than
        % fixationhrange and fixationvrange then considered to be part of a single fixation
        for efi = fixationduration:nPoints
            if sum([sum(GazeData.left_validity(1+efi-fixationduration:efi)),sum((GazeData.right_validity(1+efi-fixationduration:efi)))]) == 0 %if all rows of tracked data have Tobii validity indicator of 0
                if max(gazePoints(1+efi-fixationduration:efi,1)) - min(gazePoints(1+efi-fixationduration:efi,1))<= fixationhrange %if gaze x remains within spatial range
                    if max(gazePoints(1+efi-fixationduration:efi,2)) - min(gazePoints(1+efi-fixationduration:efi,2))<= fixationvrange %if gaze y remains within spatial range
                        fixIndicator(1+efi-fixationduration:efi) = 1;
                    end;
                end;
            end;
        end;
        
        %count the fixations, their average centre coordinates and duration
        fixok = 0;
        fixStats = [];
        
        fixationcount = 0;
        
        fixatedx = 0;
        fixatedy = 0;
        fixatets = 0;
        fixationlength = 0;
        timepoints = 0;
        
        for efi = fixationduration:nPoints
            if fixIndicator(efi) == 1
                if fixIndicator(efi-1) == 0;
                    if fixationcount > 0; %first time thru?
                        fixStats(fixationcount,1) = fixatedx/timepoints;
                        fixStats(fixationcount,2) = fixatedy/timepoints;
                        fixStats(fixationcount,3) = fixationlength;
                        fixStats(fixationcount,4) = fixatets/timepoints;
                        fixok = 1;
                    end;
                    fixatedx = 0;
                    fixatedy = 0;
                    fixatets = 0;
                    fixationlength = 0;
                    timepoints = 0;
                    fixationcount = fixationcount + 1;
                end;
                fixatedx = fixatedx + gazePoints(efi,1);
                fixatedy = fixatedy + gazePoints(efi,2);
                fixatets = fixatets + timestamp(efi);
                fixationlength = fixationlength + 1000/60;
                timepoints = timepoints + 1;
            end;
        end;
        if fixIndicator(efi-1) == 1; %ends on a fixation?
            fixStats(fixationcount,1) = fixatedx/timepoints;
            fixStats(fixationcount,2) = fixatedy/timepoints;
            fixStats(fixationcount,3) = fixationlength;
            fixStats(fixationcount,4) = fixatets/timepoints;
            fixok = 1;
        end;
        
        % convert to screen coordinates
        if ~isempty(fixStats)
            fixStats(:,1) = fixStats(:,1)*screenSiz(1,1);
            fixStats(:,2) = fixStats(:,2)*screenSiz(2,2);
        end
        
        %produce simple scatter plot of the fixation centres with circles sized to
        %match the fixation duration at that point
        if fixok == 0
            disp('NO FIXATIONS DETECTED');
            % else
            %     fixStats(:,1) = 1-fixStats(:,1); %flips x-coordinates to match plot axis
            %     fixStats(:,2) = 1-fixStats(:,2); %flips y-coordinates to match plot axis
            %     scatter (fixStats(:,1),fixStats(:,2),fixStats(:,3));
            %     axis([0 1 0 1]);
        end;
        
        %write out the analysed file
        %csvwrite(strcat(path,'\fixations.csv'),DATA);
        
        
    end

    function [ gazePoints, fixIndicator, fixStats ] = astef( gazedataleft, gazedataright, timestamp )
        
        % Tune these values to control fixations
        iFixationRadius = 28;
        iMinFixDuration = 100; % [ms]
        
        iFixationStart = SFDFixPoint();
        iFixationEnd = SFDFixPoint();
        
        % the final array of fixations
        fixation = [];
        
        % tmp variables
        iNewPotentialFixFirstPointIndex = 0;
        iPoints = [];
        iNextPoints = [];
        iPreviousPoint = [];
        iPotentialFixationCenter = [];
        
        GazeData = ParseGazeData(gazedataleft, gazedataright);
        
        nPoints = size(gazedataleft,1);
        %calculate the average x and y gaze coordinates from the left and right eye
        %positions from Tobii
        gazePoints(:,1) = 0.5 * (GazeData.left_gaze_point_2d.x + GazeData.right_gaze_point_2d.x); % Gaze Point X
        gazePoints(:,2) = 0.5 * (GazeData.left_gaze_point_2d.y + GazeData.right_gaze_point_2d.y); % Gaze Point Y
        %         screenSiz = [768 0; 0 1024];
        
        gazePoints = gazePoints * screenSiz;
        
        for gpIdx = 3:nPoints % astef original implementation starts from 3
            if GazeData.left_validity(gpIdx) == 0 && GazeData.right_validity(gpIdx) == 0
                AddPoint(gazePoints(gpIdx,1),gazePoints(gpIdx,2),timestamp(gpIdx));
            end
        end
        
        fixIndicator = []; % not used in this version
        fixStats = fixation;
        
        
        function gazePoint = SFDGazePoint()
            gazePoint.X = 0;
            gazePoint.Y = 0;
            gazePoint.Time = 0;
            gazePoint.Duration = 0;
        end
        
        function gazePoint = SFDFixPoint()
            gazePoint.X = 0;
            gazePoint.Y = 0;
            gazePoint.Time = 0;
            gazePoint.Duration = 0;
        end
        
        function AddPoint(x,y,time)
            
            aPoint=SFDGazePoint();
            aPoint.X=x;
            aPoint.Y=y;
            aPoint.Time=time;
            
            if (~isempty(iPoints)) % iPoints - main buffer
                canContinue = true;
                if(length(iPoints) == 1) % only one point in buffer
                    jump = GetDistance(aPoint, iPreviousPoint);
                    if(jump > iFixationRadius)
                        canContinue = false;
                        iPoints(1) = aPoint; % replace by the new point
                        iPotentialFixationCenter.X = aPoint.X;
                        iPotentialFixationCenter.Y = aPoint.Y;
                    end
                end
                
                if(canContinue)
                    jump = GetDistance(aPoint, iPotentialFixationCenter);
                    if(jump < iFixationRadius) % point is inside the circle
                        if(iNewPotentialFixFirstPointIndex >= 1) % we had one or more points are out of the
                            % circlebut now the re-entring occured, and we bring
                            % them back into the current fixation
                            for i = 1:length(iNextPoints) % iNextPoints - buffer with points
                                % of the new potential fixation
                                iPoints = [iPoints iNextPoints(i)];
                            end
                            iNextPoints = []; % empty the buffer of new ponetial % fixation
                            iNewPotentialFixFirstPointIndex = 0;
                        end
                        
                        iPoints = [iPoints aPoint];
                        CheckForFixStart();
                        
                        iPotentialFixationCenter.X = GetAvgX(iPoints); % calculates the center of the current
                        % fixation
                        iPotentialFixationCenter.Y = GetAvgY(iPoints);
                    else % the point is outside of the circle
                        addPoint = true;
                        if(GetDuration(length(iPoints)) >= iMinFixDuration) % "the current potential
                            % fixation" is long enough to become simply "the current fixation"
                            if(true)
                                if(iNewPotentialFixFirstPointIndex < 1) % we hadn't points out of the current
                                    % fixation yet
                                    iNewPotentialFixFirstPointIndex = length(iPoints)+1;% remember index of this point
                                    iNextPoints = [iNextPoints aPoint]; % start filling the buffer of the new
                                    % potential fixation
                                    addPoint = false;
                                elseif(aPoint.Time - iNextPoints(1).Time < iMinFixDuration) % the new
                                    % potential fixation is not long enough yet to close the
                                    % current potential fixation
                                    iNextPoints = [iNextPoints aPoint]; % continue filling the buffer of the new
                                    % potential fixation
                                    addPoint = false;
                                else          % the new potential fixation is long enough, so we close the
                                    % current potential fixation, and concide the new potential fixation
                                    % the as current one.
                                    FinishFix();
                                    
                                    iPoints = [];
                                    iNewPotentialFixFirstPointIndex = 0;
                                    
                                    for i = 1:length(iNextPoints) % move points to the right buffer
                                        p = iNextPoints(i);
                                        AddPoint(p.X,p.Y,p.Time); % yes, recursive call of this function.
                                        % we need to perform all checking again to be sure that all
                                        % points are valid fixation points
                                    end
                                    
                                    iNextPoints = [];
                                    
                                    AddPoint(aPoint.X,aPoint.Y,aPoint.Time);
                                    addPoint = false;
                                end
                            end
                        else     % the current potential fixation is too short, and we discard all the points
                            % collected
                            iPoints = [];
                        end
                        
                        if(addPoint)
                            iPoints = [iPoints aPoint];
                            CheckForFixStart();
                            
                            iPotentialFixationCenter.X = GetAvgX(iPoints);
                            iPotentialFixationCenter.Y = GetAvgY(iPoints);
                        end
                    end
                end
            else     % here we come only when the first point comes
                iPoints = [iPoints aPoint];
                CheckForFixStart();
                
                iPotentialFixationCenter.X = aPoint.X;
                iPotentialFixationCenter.Y = aPoint.Y;
            end
            
            iPreviousPoint = aPoint;
        end
        
        function CheckForFixStart()
            if(length(iPoints) > 1)
                if(GetDuration(length(iPoints) - 1) >= iMinFixDuration)
                    if(iFixationStart.Time == 0)
                        iFixationStart.Time = iPoints(1).Time;
                        iFixationStart.Duration = 0;
                        iFixationStart.X = GetAvgX(iPoints);
                        iFixationStart.Y = GetAvgY(iPoints);
                        %Fire_FixationStart(iFixationStart); % notify our application about the new fixation
                        % started
                    end
                else
                    iFixationStart.Time = 0;
                end
            end
        end
        
        function FinishFix()
            iFixationEnd.Time = iFixationStart.Time;
            iFixationEnd.Duration = iPoints(iNewPotentialFixFirstPointIndex - 1).Time - iFixationEnd.Time;
            
            iFixationEnd.X = GetAvgX(iPoints, 1, iNewPotentialFixFirstPointIndex); % only points from 0
            iFixationEnd.Y = GetAvgY(iPoints, 1, iNewPotentialFixFirstPointIndex); % till
            % iNewPotentialFixFirstPointIndex
            
            if (iFixationEnd.Duration >= iMinFixDuration && iFixationEnd.Time > 0)
                fixTmp = [iFixationEnd.X iFixationEnd.Y iFixationEnd.Duration iFixationEnd.Time];
                fixation = [fixation; fixTmp];  % CLAUDIO already converted to our format!
                %Fire_FixationEnd(iFixationEnd); % notify our application about the current fixation
                % finished
            end
            
            iFixationStart.Time = 0;
        end
        
        
        
        function avg = GetAvgX(list, ini, f)
            v=0;
            if nargin == 1
                for p = list
                    v = v + p.X;
                end
                avg =  v/length(list);
            else
                for p=list(ini:f-1)
                    v = v + p.X;
                end
                avg = v/(f-ini);
            end
        end
        
        function avg = GetAvgY(list, ini, f)
            v=0;
            if nargin == 1
                for p = list
                    v = v + p.Y;
                end
                avg =  v/length(list);
            else
                for p=list(ini:f-1)
                    v = v + p.Y;
                end
                avg = v/(f-ini);
            end
        end
        
        function duration = GetDuration(count)
            duration =  iPoints(count).Time - iPoints(1).Time;
        end
        
        function distance = GetDistance(a,b)
            distance = sqrt((a.X-b.X)*(a.X-b.X)+(a.Y-b.Y)*(a.Y-b.Y));
        end
    end

    function out = getFirstTimestamp(fname)
        out = -1;
        if ~isempty(fname) && exist(fname,'file')
            SV = load(fname);
            out = SV.timestamp;
        end
    end

    function [] = setFirstTimestamp(timestamp,fname) %#ok<INUSL>
        if ~isempty(fname)
            save(fname,'timestamp');
        end
    end

end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FixId.cs (excerpt)
%
% Original ASTEF fixation identification
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% public class Fixation
% 	{
%
% 		public Fixation(int r,int i)
% 		{
% 			iFixationRadius=r;
% 			iMinFixDuration=i;
% 		}
%
% 		int iFixationRadius=0;
% 		int iMinFixDuration=0;
%
% 		public struct SFDGazePoint
% 		{
% 			public int X;
% 			public int Y;
% 			public int Time;
% 			public string v1;
% 			public string v2;
% 		}
%
% 		public struct SFDFixPoint
% 		{
% 			public int X;
% 			public int Y;
% 			public int Time;
% 			public int Duration;
% 			public string v1;
% 			public string v2;
% 		}
%
%
% 		SFDFixPoint iFixationStart=new SFDFixPoint();
% 		SFDFixPoint iFixationEnd=new SFDFixPoint();
%
% 		public ArrayList fixation=new ArrayList();
% 		// Initially,
% 		//
% 		int iNewPotentialFixFirstPointIndex = -1;
% 		ArrayList iPoints =new ArrayList();
% 		ArrayList iNextPoints =new ArrayList();
% 		SFDGazePoint iPreviousPoint ;
% 		SFDGazePoint iPotentialFixationCenter;
% 		//---------------------------------------------------------------------------
% 		public void AddPoint(int x,int y,int time,string v1,string v2)//SFDGazePoint aPoint)
% 		{
%
% 			SFDGazePoint aPoint=new SFDGazePoint();
% 			aPoint.X=x;
% 			aPoint.Y=y;
% 			aPoint.Time=time;
% 			aPoint.v1=v1;
% 			aPoint.v2=v2;
% 			if(iPoints.Count > 0) // iPoints - main buffer
% 			{
% 				bool canContinue = true;
% 				if(iPoints.Count == 1) // only one point in buffer
% 				{
% 					double jump = GetDistance(aPoint, iPreviousPoint);
% 					if(jump > iFixationRadius)
% 					{
% 						canContinue = false;
% 						iPoints.RemoveAt(0); // replace by the new point
% 						iPoints.Add(aPoint);
% 						iPotentialFixationCenter.X = aPoint.X;
% 						iPotentialFixationCenter.Y = aPoint.Y;
% 					}
% 				}
%
% 				if(canContinue)
% 				{
% 					double jump = GetDistance(aPoint, iPotentialFixationCenter);
% 					if(jump < iFixationRadius) // point is inside the circle
% 					{
% 						if(iNewPotentialFixFirstPointIndex >= 0) // we had one or more points are out of the
% 							// circlebut now the re-entring occured, and we bring
% 							// them back into the current fixation
% 						{
% 							for(int i = 0; i < iNextPoints.Count; i++) // iNextPoints - buffer with points
% 								// of the new potential fixation
% 							{
% 								iPoints.Add(iNextPoints[i]);
% 							}
% 							iNextPoints.Clear(); // empty the buffer of new ponetial // fixation
% 							iNewPotentialFixFirstPointIndex = -1;
% 						}
%
% 						iPoints.Add(aPoint);
% 						CheckForFixStart();
%
% 						iPotentialFixationCenter.X = (int)GetAvgX(iPoints); // calculates the center of the current
% 						// fixation
% 						iPotentialFixationCenter.Y = (int)GetAvgY(iPoints);
% 					}
% 					else // the point is outside of the circle
% 					{
% 						bool addPoint = true;
% 						if(GetDuration(iPoints.Count) >= iMinFixDuration) // "the current potential
% 							// fixation" is long enough to become simply "the current fixation"
% 						{
% 							if(true)
% 							{
% 								if(iNewPotentialFixFirstPointIndex < 0) // we hadn't points out of the current
% 									// fixation yet
% 								{
% 									iNewPotentialFixFirstPointIndex = iPoints.Count;// remember index of this point
% 									iNextPoints.Add(aPoint); // start filling the buffer of the new
% 									// potential fixation
% 									addPoint = false;
% 								}
% 								else if(aPoint.Time - ((SFDGazePoint)iNextPoints[0]).Time < iMinFixDuration) // the new
% 									// potential fixation is not long enough yet to close the
% 									// current potential fixation
% 								{
% 									iNextPoints.Add(aPoint); // continue filling the buffer of the new
% 									// potential fixation
% 									addPoint = false;
% 								}
% 								else          // the new potential fixation is long enough, so we close the
% 									// current potential fixation, and concide the new potential fixation
% 									// the as current one.
% 								{
% 									FinishFix();
%
% 									iPoints.Clear();
% 									iNewPotentialFixFirstPointIndex = -1;
%
% 									for(int i = 0; i < iNextPoints.Count; i++) // move points to the right buffer
% 									{
% 										SFDGazePoint p=(SFDGazePoint)iNextPoints[i];
% 										AddPoint(p.X,p.Y,p.Time,p.v1,p.v2); // yes, recursive call of this function.
% 										// we need to perform all checking again to be sure that all
% 										// points are valid fixation points
% 									}
%
% 									iNextPoints.Clear();
%
% 									AddPoint(aPoint.X,aPoint.Y,aPoint.Time,aPoint.v1,aPoint.v2);
% 									addPoint = false;
% 								}
% 							}
%
% 						}
% 						else     // the current potential fixation is too short, and we discard all the points
% 							// collected
% 						{
% 							iPoints.Clear();
% 						}
%
% 						if(addPoint)
% 						{
% 							iPoints.Add(aPoint);
% 							CheckForFixStart();
%
% 							iPotentialFixationCenter.X = (int)GetAvgX(iPoints);
% 							iPotentialFixationCenter.Y = (int)GetAvgY(iPoints);
% 						}
% 					}
% 				}
% 			}
% 			else     // here we come only when the first point comes
% 			{
% 				iPoints.Add(aPoint);
% 				CheckForFixStart();
%
% 				iPotentialFixationCenter.X = aPoint.X;
% 				iPotentialFixationCenter.Y = aPoint.Y;
% 			}
%
% 			iPreviousPoint = aPoint;
% 		}
%
%
% 		//---------------------------------------------------------------------------
% 		void CheckForFixStart()
% 		{
% 			if(iPoints.Count > 1)
% 			{
% 				if(GetDuration(iPoints.Count - 1) >= iMinFixDuration)
% 				{
% 					if(iFixationStart.Time == 0)
% 					{
% 						iFixationStart.Time = ((SFDGazePoint)iPoints[0]).Time;
% 						iFixationStart.Duration = 0;
% 						iFixationStart.X = (int)GetAvgX(iPoints);
% 						iFixationStart.Y = (int)GetAvgY(iPoints);
% 						iFixationStart.v1=((SFDGazePoint)iPoints[0]).v1;
% 						iFixationStart.v2=((SFDGazePoint)iPoints[0]).v2;
% 						//Fire_FixationStart(iFixationStart); // notify our application about the new fixation
% 						// started
% 					}
% 				}
% 				else
% 				{
% 					iFixationStart.Time = 0;
% 				}
% 			}
% 		}
%
%
% 		//---------------------------------------------------------------------------
% 		public void FinishFix()
% 		{
% 			iFixationEnd.Time = iFixationStart.Time;
% 			iFixationEnd.Duration = ((SFDGazePoint)iPoints[iNewPotentialFixFirstPointIndex - 1]).Time -
% 				iFixationEnd.Time;
%
% 			iFixationEnd.X = (int)GetAvgX(iPoints, 0, iNewPotentialFixFirstPointIndex); // only points from 0
% 			iFixationEnd.Y = (int)GetAvgY(iPoints, 0, iNewPotentialFixFirstPointIndex); // till
% 			// iNewPotentialFixFirstPointIndex
%
% 			iFixationEnd.v1=iFixationStart.v1;
% 			iFixationEnd.v2=iFixationStart.v2;
%
% 			if(iFixationEnd.Duration >= iMinFixDuration && iFixationEnd.Time > 0)
% 			{
% 				fixation.Add(iFixationEnd);
% 				//Fire_FixationEnd(iFixationEnd); // notify our application about the current fixation
% 				// finished
% 			}
%
% 			iFixationStart.Time = 0;
% 		}
%
%
%
% 		public float GetAvgX(ArrayList list)
% 		{
% 			float v=0;
% 			foreach(SFDGazePoint p in list)
% 			{
% 				v+=p.X;
% 			}
% 			return v/list.Count;
% 		}
%
% 		public float GetAvgX(ArrayList list,int ini,int f)
% 		{
% 			float v=0;
% 			for(int i=ini;i<f;i++)
% 			{
% 				v+=((SFDGazePoint)list[i]).X;
% 			}
% 			return v/(f-ini);
% 		}
%
%
% 		public float GetAvgY(ArrayList list)
% 		{
% 			float v=0;
% 			foreach(SFDGazePoint p in list)
% 			{
% 				v+=p.Y;
% 			}
% 			return v/list.Count;
% 		}
%
% 		public float GetAvgY(ArrayList list,int ini,int f)
% 		{
% 			float v=0;
% 			for(int i=ini;i<f;i++)
% 			{
% 				v+=((SFDGazePoint)list[i]).Y;
% 			}
% 			return v/(f-ini);
% 		}
%
%
% 		public int GetDuration(int count)
% 		{
% 			return ((SFDGazePoint) iPoints[count-1]).Time-((SFDGazePoint)iPoints[0]).Time;
% 		}
%
% 		private double GetDistance(SFDGazePoint a,SFDGazePoint b)
% 		{
% 			return Math.Sqrt((a.X-b.X)*(a.X-b.X)+(a.Y-b.Y)*(a.Y-b.Y));
% 		}
% 	}