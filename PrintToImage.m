
classdef PrintToImage
	properties
	end
	methods
		function My= PrintToImage(hFigure, ImagePath, Size)
			% Prepare Page Setup & Export To Image File %
			hWait= waitbar(0, 'Wait For Image Export', 'Name', 'Printer Module ...');
			
			if isempty(ImagePath), ImagePath= 'TempPrint'; end
			% Aspect Ratio: Width / Height %
			if isempty(Size)
				% To Fit Elsevier Journal %
				Size = [10.1, 3];
				% To Fit On A4 %
				Size= [210 297]/10;
			end
			
			% Initialize Print Setup %
            Prp.Color               = 'white';
			Prp.PaperPositionMode	= 'Manual';
			Prp.InvertHardcopy		= 'Off';
			Prp.PaperUnits			= 'Centimeters';
			Prp.PaperType			= 'A4';
			Prp.PaperOrientation	= 'Landscape';
			Prp.PaperOrientation	= 'Portrait';
			Prp.Renderer			= 'ZBuffer';
			Prp.Renderer			= 'OpenGL';
			Prp.Renderer			= 'Painters';
			
			set(hFigure, Prp);
			
			Prp.PaperPosition		= My.CalcPaperPosition(hFigure, Size);
			set(hFigure, Prp);
			
% 			print(hFigure, '-dpng', '-loose', '-r600', ImagePath);
% print(hFigure, '-depsc', '-loose', ImagePath) 
% print(hFigure, '-dpsc', '-loose', ImagePath) 
% print(hFigure, '-depsc2', '-loose', ImagePath)            
print(hFigure, '-depsc2', ImagePath)
			
			
			delete(hWait);
			
			delete(hFigure);
		end
		function PaperPosition= CalcPaperPosition(My, hFigure, Size)
			% Centered Figure %
			pSize= get(hFigure, 'PaperSize');
			% Chart Dimension %
			wChart= Size(1);
			hChart= Size(2);
			lChart= (pSize(1)- wChart)/ 2;
			bChart= (pSize(2)- hChart)/ 2;
			
			PaperPosition= [lChart, bChart, wChart, hChart];
		end
	end
end
