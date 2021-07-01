-- параметры испытаний
iterations = 1500000; -- число испытаний
timeout_limit = 10; -- число попыток, если не убили за это число ходов то ничья

-- статы персонажей
char = {};
char [1] = {};
char [2] = {};

char[1]["health"] = 1200;
char[1]["damage"] = 125;
char[1]["damage_variation"] = 5;
char[1]["chancetohit"] = 0.80;
char[1]["crit"] = 0.25;

char[2]["health"] = 1000;
char[2]["damage"] = 110;
char[2]["damage_variation"] = 5;
char[2]["chancetohit"] = 0.85;
char[2]["crit"] = 0.44;

-- обнуляем переменные 
char_A_wins = 0;
char_B_wins = 0;
char_AB_wins = 0;
timeout_count = 0;

-- функция проверки шанса попасть
IsDamage = function(chance)
   local isdamage1 = false;
   local r = math.random();
   if (r<chance) then 
      isdamage1 = true; 
   end
   return isdamage1;
end

-- функция проверки шанса крита
IsCrit = function(chance)
   local iscrit1 = false;
   local r = math.random();
   if (r<chance) then 
      iscrit1 = true; 
   end
   return iscrit1;
end
-- функция вычисления урона который нанесет персонаж
GetDamage = function(char1)
   local damage_min = math.max(char1.damage-char1.damage_variation, 1);--нельзя нанести отрицательный урон
   local damage_max = math.max(char1.damage+char1.damage_variation, 1);--нельзя нанести отрицательный урон
   return math.random (damage_min,damage_max);
end


-- инициализация генератора случайных чисел
math.randomseed(os.time());

-- основной цикл
for i = 1, iterations do 
   local char_A_health = char[1].health;
   local char_B_health = char[2].health;
   local char_A_dead = false;
   local char_B_dead = false;
   -- i2 = число попыток, если не убили за это число ходов то ничья
   for i2 = 1, timeout_limit do 
         if (IsDamage (char[2].chancetohit)) then char_A_health = char_A_health  - GetDamage(char[2]); end
         if (IsDamage (char[1].chancetohit)) then char_B_health = char_B_health  - GetDamage(char[1]); end
         if (IsCrit (char[2].crit)) then char_A_health = char_A_health  - GetDamage(char[2])*2; end
         if (IsCrit (char[1].crit)) then char_B_health = char_B_health  - GetDamage(char[1])*2; end
         if (char_A_health<=0) then 
            char_A_dead = true;
         end
         if (char_B_health<=0) then 
            char_B_dead = true;
         end
         if (char_A_dead or char_B_dead) then 
            break;
         end
   end	
   if (not(char_A_dead)) and( not(char_B_dead)) then 
         -- считаем ничьи по таймауту отдельно
         timeout_count = timeout_count +1;
      else
         if (char_A_dead and char_B_dead) then 
             -- ничья без таймаута
             char_AB_wins = char_AB_wins + 1;  
         else
            if (char_A_dead) then 
             -- победил B
             char_B_wins = char_B_wins + 1;  
            end
            if (char_B_dead) then 
             -- победил A
             char_A_wins = char_A_wins + 1;  
            end
         end
      end
end
print ("Petya wins =" .. char_A_wins .. " (" .. (100*char_A_wins/(char_A_wins+char_B_wins+char_AB_wins+timeout_count)) .. "%)");
print ("Vasya wins =" .. char_B_wins .. " (" .. (100*char_B_wins/(char_A_wins+char_B_wins+char_AB_wins+timeout_count)) .. "%)");
print ("Nichya =" .. char_AB_wins .. " (" .. (100*char_AB_wins/(char_A_wins+char_B_wins+char_AB_wins+timeout_count)) .. "%)");
print ("timeout =" .. timeout_count .. " (" .. (100*timeout_count/(char_A_wins+char_B_wins+char_AB_wins+timeout_count)) .. "%)");

