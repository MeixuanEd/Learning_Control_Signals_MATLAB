classdef ControlSignalPath < handle
    % Stores output of a learned control signal path, produced by the
    % function learn_control_signals.m
    %
    % Also contains the results of metric evaluations used to determine the
    % "best" or "true" control signals
    
    properties
        % Settings from original object
        learn_control_signals_settings
        % Dynamics
        all_A
        all_B
        % Control signals
        all_U
        
        % Metric evaluations
        objective_function
        objective_values
        
        % Best values and model
        best_index
        A
        B
        U
    end
    
    methods
        function self = ControlSignalPath(settings, all_A, all_B, all_U)
            % Imports data produced by learn_control_signals.m
            self.learn_control_signals_settings = settings;
            
            self.all_A = all_A;
            self.all_B = all_B;
            self.all_U = all_U;
        end
        
        function calc_best_control_signal(self, objective_function)
            % Calculates the best control signal, according to function
            % 'objective_function' which is saved in this object
            
            self.objective_function = objective_function;
            
            vals = zeros(size(self.all_U));
            for i = 1:length(self.all_U)
%                 all_nnz(i) = nnz(all_U{i});
                vals(i) = acf(self.all_U{i}', 1, false);
            end
            vals(end) = vals(end-1);
            self.objective_values = vals;
            
            % Get maximum of above
            [~, i] = max(vals);
            self.best_index = i;
            self.U = self.all_U{i};
            self.A = self.all_A{i};
            self.B = self.all_B{i};
        end
    end
end

