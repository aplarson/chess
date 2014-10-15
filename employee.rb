class Employee
  attr_reader :salary
  
  def initialize(salary, name, title, boss)
    @salary = salary
    @name = name
    @title = title
    @boss = boss
  end
  
  def bonus(multiplier)
    self.salary * multiplier
  end
  
  def eligible_salary
    self.salary
  end
end

class Manager < Employee
  attr_reader :employees
  
  def initialize(salary, name, title, boss, employees)
    super(salary, name, title, boss)
    @employees = employees
  end
  
  def bonus(multiplier)
    (eligible_salary - self.salary) * multiplier
  end
  
  def eligible_salary
    employees.inject(self.salary) do |sum, employee|
        p sum + employee.eligible_salary
    end
  end
end

ceo = Manager.new(100, "Bezos", "big boss", nil, [])
mm1 = Manager.new(80, "Andrew", "medium boss", ceo, [])
mm2 = Manager.new(80, "Sam", "medium employee", ceo, [])
e = Employee.new(50, "Bob", "small employee", mm1)
e2 = Employee.new(50, "John", "tiny employee", mm1)

ceo.employees << mm1 << mm2
mm1.employees << e << e2

p mm1.bonus(1)

