stepI = "tests/StepInput";
stepIF = "tests/StepInputFlip";

response = containers.Map();
for i = 0:2
    response("I"+num2str(i)) = readmatrix(stepI+num2str(i)+".csv");
    response("IF"+num2str(i)) = readmatrix(stepIF+num2str(i)+".csv");
end

