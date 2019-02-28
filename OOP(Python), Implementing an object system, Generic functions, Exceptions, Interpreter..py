'''Lior Lugasi, 203962006'''

#-----------------Q1-----------------#
class Date():
    def __init__(self,year=2017,month=1,day=1):
        """For initialize the instance of class Date"""
        self.day=day
        self.month=month
        self.year=year
    def __repr__(self):
        """A function that creates and returns a string (constructor) represents the instance, representation of the function is designed to the interpeter"""
        return "Date ({0},{1},{2})".format(self.year,self.month,self.day)
    def __str__(self):
        """The function returns a string that represents the instance in a clear and understandable way to the user"""
        datename=str(self.day)
        datename+='th of'
        datename+=self.getmonth()
        datename+=','
        datename+=str(self.year)   
        return datename
    def getmonth(self):
        """Return month according to the number"""
        if self.month==1:
            return 'January'
        elif self.month==2:
            return 'February'
        elif self.month==3:
            return 'March'
        elif self.month==4:
            return "April"
        elif self.month==5:
            return 'may'
        elif self.month==6:
            return 'June'
        elif self.month==7:
            return 'July'
        elif self.month==8:
            return 'August'
        elif self.month==9:
            return 'September'
        elif self.month==10:
            return 'October'
        elif self.month==11:
            return 'November'
        elif self.month==12:
            return 'December'

class Time():
    def __init__(self,hours=0,minute=0):
        """For initialize the instance of class Time"""
        self.hours=hours
        self.minute=minute
    def __repr__(self):
        """A function that creates and returns a string (constructor) represents the instance, representation of the function is designed to the interpeter"""
        return "Time({0},{1})".format(self.hours,self.minute)
    def __str__(self):
        """The function returns a string that represents the instance in a clear and understandable way to the user"""
        time=""
        if self.hours<10:
            time+="0"+str(self.hour)+":"
            if self.minute<10:
                time+="0"+str(self.minute)
                return time
        time+=str(self.hours)+':'
        if self.minute<10:
                time+="0"+str(self.minute)
                return time
        time+=+str(self.minute)
        return time
class CalendarEntry():
    def __init__(self,year=2017,month=1,day=1):
        """For initialize the instance of class CalendarEntry"""
        self.year=year
        self.month=month
        self.day=day
        self.tasks={}
        self.mylist=[]
        self.date=Date(year,month,day)
    def addTask(self,task,start,end):
        """Function that create task and list of tasks"""
        tuples=(str(start),str(end))
        if tuples not in self.tasks:
            self.mylist+=[str(start)+'-'+str(end)+'-'+task]
            self.tasks[tuples]=task
        else:
            print ("There is already a task in those hours")
    def __repr__(self):
        """A function that creates and returns a string (constructor) represents the instance, representation of the function is designed to the interpeter"""
        return "CalendarEntry({0},{1},{2})".format(self.day,self.month,self.year)
    def __str__(self):
        """The function returns a string that represents the instance in a clear and understandable way to the user"""
        print("Todo list for",self.date,":")
        for i in range(len(self.mylist)):
            print("{0}{1} {2}".format(i+1,'.',self.mylist[i]))
        return''

#-----------------Q2-----------------#
def make_class(attributes, base_class=None):
    """Return a new class, which is a dispatch dictionary."""
    def get_value(name):
        if name in attributes:
            return attributes[name]
        elif base_class is not None:
            return base_class['get'](name)
    def set_value(name, value):
        attributes[name] = value
    def new(*args):
        return init_instance(cls, *args)
    def make_instance(cls):
        """Return a new object instance, which is a dispatch dictionary."""
        attributes = {}
        def get_value(name):
            if name in attributes:
                return attributes[name]
            else:
                value = cls['get'](name)
                return bind_method(value, instance)
        def set_value(name, value):
            attributes[name] = value
        def bind_method(value, instance):
            """Return a bound method if value is callable, or value otherwise."""
            if callable(value):
                def method(*args):
                    return value(instance, *args)
                return method
            else:
                return value
        instance = {'get': get_value, 'set': set_value}
        return instance
        
    def init_instance(cls, *args):
        """Return a new object with type cls, initialized with args."""
        instance = make_instance(cls)
        init = cls['get']('__init__')
        if init:
            init(instance, *args)
            return instance
    cls = {'get': get_value, 'set': set_value, 'new': new}
    return cls
    
def make_date_class():
    def __init__(self,year=2017,month=1,day=1):
        "For initialize the instance of class Date"
        self['set']('day',day)
        self['set']('month',month)
        self['set']('year',year)
    return make_class({'__init__': __init__})

def make_time_class():
    def __init__(self,hours=0,minute=0):
        """For initialize the instance of class Time"""
        self['set']('hours',hours)
        self['set']('minute',minute)
    def __str__(self):
        """The function returns a string that represents the instance in a clear and understandable way to the user"""
        time=""
        if self['get']('hours')<10:
            time+="0"+str(self['get']('hour'))+":"
            if self['get']('minute')<10:
                time+="0"+str(self['get']('minute'))
                return time
        time+=str(self['get']('hours'))+':'
        if self['get']('minute')<10:
                time+="0"+str(self['get']('minute'))
                return time
        time+=+str(self['get']('minute'))
        return time
        
    return make_class({'__init__': __init__,'__str__':__str__})

def make_calentry_class():
    def __init__(self,year=2017,month=1,day=1):
        "For initialize the instance of class CalendarEntry"
        self['set']('day',day)
        self['set']('month',month)
        self['set']('year',year)
        self['set']('tasks',{})
    
    def addTask(self,task,start,end):
        """Function that create task and list of tasks"""
        tuples = (start['get']('__str__')(), end['get']('__str__')())  #Tuple of two times#
        if tuples not in self['get']('tasks'):      #If the key(the tuple) is in the dictionary#
            self['get']('tasks')[tuples] = task
        else:
            return ("Theres already task in those hours")

    return make_class({'__init__': __init__,'addTask':addTask})



#-----------------Q3-----------------#
class Shekel():
    def __init__(self,value):
        """For initialize the instance of class Shekel"""
        self.value=value
    def amount(self):
        """Return the value of the instance of class Shekel"""
        return self.value
    def __add__(self,obj):
        """Add between the two instances will return the sum in shekels"""
        return self.value+obj.value
    def __str__(self):
        """The function returns a string that represents the instance in a clear and understandable way to the user"""
        return("{0}NIS".format(self.value))
    def __repr__(self):
        """A function that creates and returns a string (constructor) represents the instance, representation of the function is designed to the interpeter"""
        return("Shekel({0})".format(self.value))

class Dollar():
    def __init__(self,value):
        """For initialize the instance of class Dollar"""
        self.value=value
    def amount(self):
        """Return the value of the instance of class Dollar in Shekels"""
        return self.value*rates[('dollar','nis')]
    def __add__(self,obj):
        """Add between the two instances will return the sum in shekels"""
        return self.amount()+obj.amount()
    def __str__(self):
        """The function returns a string that represents the instance in a clear and understandable way to the user"""
        return("{0}$".format(self.value))
    def __repr__(self):
        """A function that creates and returns a string (constructor) represents the instance, representation of the function is designed to the interpeter"""
        return "Dollar({0})".format(self.value)
class Euro():
    def __init__(self,value):
        """For initialize the instance of class Euro"""
        self.value=value
    def amount(self):
        """Return the value of the instance of class Euro in Shekels"""
        return self.value*rates[('euro','nis')]
    def __add__(self,obj):
        """Add between the two instances will return the sum in shekels"""
        return self.amount()+obj.amount()
    def __str__(self):
        """The function returns a string that represents the instance in a clear and understandable way to the user"""
        return("{0}euro".format(self.value))
    def __repr__(self):
        """A function that creates and returns a string (constructor) represents the instance, representation of the function is designed to the interpeter"""
        return "Euro({0})".format(self.value) 

def add(x,y):
    """Add between the two objects will return the sum in shekels"""
    return x.amount()+y.amount()

rates={('dollar','nis'):3.82,('euro','nis'):4.07}



#-----------------Q4-----------------#
def type_tag(x):
    """return the value from the dictionary type_tag.tags"""
    return type_tag.tags[type(x)]
    
type_tag.tags = {Dollar: 'dollar',Shekel: 'nis', Euro: 'euro'}

def sub(x,y):
    """sub between the two objects will return the sum in shekels"""
    return x.amount()-y.amount()

def apply(operator_name, x, y):
    """Function that apply to add or sub between two arguments"""
    tags = (type_tag(x), type_tag(y))
    key = (operator_name, tags)
    result=apply.implementations[key](x, y)
    if(type(x) is Shekel):
        return Shekel(round(result, 2))
    if(type(x) is Dollar):
        return Dollar(round(result / rates[('dollar', 'nis')], 2))
    if (type(x) is Euro):
        return Euro(round(result / rates[('euro', 'nis')], 2)) 
    
    
"""A dictionary that includes key that include tuple of operation and arguments and value that it is function"""
apply.implementations = {('add',('dollar', 'euro')): add,
                         ('add',('euro', 'dollar')): add,
                         ('add',('dollar', 'dollar')): add,
                         ('add',('dollar', 'nis')): add,
                         ('add',('nis', 'dollar')): add,
                         ('add',('nis', 'nis')): add,
                         ('add',('euro', 'nis')): add,
                         ('add',('nis', 'euro')): add,
                         ('add',('euro', 'euro')): add,
                         ('sub',('dollar', 'euro')): sub,
                         ('sub',('euro', 'dollar')): sub,
                         ('sub',('dollar', 'dollar')): sub,
                         ('sub',('dollar', 'nis')): sub,
                         ('sub',('nis', 'dollar')): sub,
                         ('sub',('nis', 'nis')): sub,
                         ('sub',('euro', 'nis')): sub,
                         ('sub',('nis', 'euro')): sub,
                         ('sub',('euro', 'euro')): sub}







#-------------Q5----------------#
def dollar_to_nis(x):
    """Function that receive object from type Dollar and returns its value in NIS"""
    return Shekel(x.amount())
def euro_to_nis(x):
    """Function that receive object from type Euro and returns its value in NIS"""
    return Shekel(x.amount)

"""A dictionary that includes key that include tuple of coins and value that it is function"""
coercions = {('dollar', 'nis'): dollar_to_nis,('euro', 'nis'): euro_to_nis}
def coerce_apply(operator_name, x, y):
    """Function that apply to convert coins to Nis"""
    tx, ty = type_tag(x), type_tag(y)
    if tx != ty:
        if (tx, ty) in coercions:
            tx, x = ty, coercions[(tx, ty)](x)
            x.value=round(x.value,2)
        elif (ty, tx) in coercions:
            ty, y = tx, coercions[(ty, tx)](y)
            y.value=round(y.value,2)
        elif (tx,ty) not in coercions:
            tx,ty='nis','nis'
            x,y=Shekel(x.amount()),Shekel(y.amount())
        else:
            return 'No coercion possible.'
    key = (operator_name, tx)
    return Shekel(coerce_apply.implementations[key](x, y))

"""A dictionary that includes key that include tuple of operation and coin and  value that it is function"""
coerce_apply.implementations = {('add','nis'):add,('sub','nis'):sub}
'''
print(coercions[('dollar','nis')](Dollar(50)))
print(coerce_apply('add', Shekel(50), Dollar(20)))
print(coerce_apply('add', Dollar(50), Euro(20)))
print(coerce_apply('sub', Dollar(50), Euro(20)))
'''

#-------------Q6----------------#

def get_reverse_map_iterator(s,g=lambda x:x):  
    """Represent the index"""
    counter=len(s)                   
    def next():
        """Return The next element"""
        nonlocal counter        
        counter=counter-1
        temp=s[counter]     #Else, return the action element consisting of a function on element from the list#
        try:

            if counter<0:       #IndexError
                raise IndexError
            temp=g(temp)
            counter-=1      #Increase the counter
        except(ArithmeticError, ValueError, TypeError):
            counter=counter-1
            return next()
        except(IndexError):     #IndexError
            return 'no more items'
        return temp
    def has_more():   
        """Return True it dosen't reach to the start of the list"""      
        if counter<0:
            return False
        return True
    return{'has_more':has_more,'next':next}

#-------------Q7----------------#
from functools import reduce
from operator import mul
from math import sqrt

class Exp(object):
    """A call expression in Calculator."""
    def __init__(self, operator, operands):
        self.operator = operator
        self.operands = operands
    def __repr__(self):
        return 'Exp({0},{1})'.format(repr(self.operator),repr(self.operands))
    def __str__(self):
        operand_strs = ', '.join(map(str, self.operands))
        return '{0}({1})'.format(self.operator, operand_strs)

def calc_eval(exp):
    """Evaluate a Calculator expression."""
    if type(exp) in (int, float):
        return exp
    elif type(exp) == Exp:
        arguments = list(map(calc_eval, exp.operands))
    return calc_apply(exp.operator, arguments)

known_operators = ['add', 'sub', 'mul', 'div','sqrt','pow', '+', '-', '*', '/','V','^'] #Add two operators :sqrt,V,pow,^#

def calc_apply(operator, args):
    """Apply the named operator to a list of args."""
    if operator in ('add', '+'):
        return sum(args)
    if operator in ('sub', '-'):
        if len(args) == 0:
            raise TypeError(operator + ' requires at least 1 argument')
        if len(args) == 1:
            return -args[0]
        return sum(args[:1] + [-arg for arg in args[1:]])
    if operator in ('mul', '*'):
        return reduce(mul, args, 1)
    if operator in ('div', '/'):
        if len(args) != 2:
            raise TypeError(operator + ' requires exactly 2 arguments')
        numer, denom = args
        return numer/denom
    if operator in ('sqrt','V'):        #Sqrt#
        if len(args)!=1:
            raise TypeError(operator + ' requires at least 1 argument')
        return sqrt(args[0])
    if operator in ('pow','^'):     #Power#
        x,y=args
        return pow(x, y)
    

def calc_parse(line):
    """Parse a line of calculator input and return an expression tree."""
    tokens = tokenize(line)
    expression_tree = analyze(tokens)
    if len(tokens) > 0:
        raise SyntaxError('Extra token(s): ' + ' '.join(tokens))
    return expression_tree

def tokenize(line):
    """Convert a string into a list of tokens."""
    spaced = line.replace('(',' ( ').replace(')',' ) ').replace(',', ' , ')
    return spaced.split()

def analyze(tokens):
    """Create a tree of nested lists from a sequence of tokens."""
    assert_non_empty(tokens)
    token = analyze_token(tokens.pop(0))
    if type(token) in (int, float):
        return token
    if token in known_operators:
        if len(tokens) == 0 or tokens.pop(0) != '(':
            raise SyntaxError('expected ( after ' + token)
        return Exp(token, analyze_operands(tokens))
    else:
        raise SyntaxError('unexpected ' + token)


def analyze_operands(tokens):
    """Analyze a sequence of comma-separated operands."""
    assert_non_empty(tokens)
    operands = []
    while tokens[0] != ')':
        if operands and tokens.pop(0) != ',':
            raise SyntaxError('expected ,')
        operands.append(analyze(tokens))
        assert_non_empty(tokens)
    tokens.pop(0) # Remove )
    return operands



def analyze_token(token):
    """Return the value of token if it can be analyzed as a number, or token."""
    try:
        return int(token)
    except (TypeError, ValueError):
        try:
            return float(token)
        except (TypeError, ValueError):
            return token


def assert_non_empty(tokens):
    """Raise an exception if tokens is empty."""
    if len(tokens) == 0:
        raise SyntaxError('unexpected end of line')


def read_eval_print_loop():
    """Run a read-eval-print loop for calculator."""
    while True:
        try:
            expression_tree = calc_parse(input('calc> '))
            print(calc_eval(expression_tree))
        except (SyntaxError, TypeError, ZeroDivisionError) as err:
            print(type(err).__name__ + ':', err)
        except (KeyboardInterrupt, EOFError): # <Control>-D, etc.
            print('Calculation completed.')
        except(ValueError)as err:           #ValueError#
            print(type(err).__name__ + ':', err)
        except(ArithmeticError)as err:
            print(type(err).__name__ + ':', err)        #ArithmeticError#
            return

'''read_eval_print_loop()'''
