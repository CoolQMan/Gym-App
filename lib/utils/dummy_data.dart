import '../models/user_model.dart';
import '../models/workout_model.dart';
import '../models/diet_model.dart';
import '../models/progress_model.dart';
import '../models/payment_model.dart';
import 'constants.dart';

class DummyData {
  // Users
  static final List<User> users = [
    User(
      id: '1',
      name: 'John Doe',
      email: 'member@example.com',
      role: AppConstants.roleMember,
      password: 'password',
      assignedTrainerId: '3',
      currentWorkoutPlanId: '1',
      currentDietPlanId: '1',
    ),
    User(
      id: '2',
      name: 'Jane Smith',
      email: 'owner@example.com',
      role: AppConstants.roleOwner,
      password: 'password',
    ),
    User(
      id: '3',
      name: 'Mike Johnson',
      email: 'trainer@example.com',
      role: AppConstants.roleTrainer,
      password: 'password',
      assignedMemberIds: ['1', '4', '5'],
    ),
    User(
      id: '4',
      name: 'Sarah Williams',
      email: 'sarah@example.com',
      role: AppConstants.roleMember,
      password: 'password',
      assignedTrainerId: '3',
    ),
    User(
      id: '5',
      name: 'Robert Brown',
      email: 'robert@example.com',
      role: AppConstants.roleMember,
      password: 'password',
      assignedTrainerId: '3',
      currentWorkoutPlanId: '2',
      currentDietPlanId: '2',
    ),
  ];

  // Workout Plans
  static final List<WorkoutPlan> workoutPlans = [
    WorkoutPlan(
      id: '1',
      name: 'Beginner Strength Training',
      description:
          'A comprehensive workout plan for beginners focusing on building strength and muscle.',
      createdBy: '3', // Trainer
      duration: '8 weeks',
      exerciseCount: 15,
      sessions: [
        WorkoutSession(
          day: 'Monday',
          exercises: [
            Exercise(name: 'Bench Press', sets: 3, reps: 10, weight: 45),
            Exercise(name: 'Squats', sets: 3, reps: 12, weight: 50),
            Exercise(name: 'Lat Pulldown', sets: 3, reps: 10, weight: 40),
          ],
        ),
        WorkoutSession(
          day: 'Wednesday',
          exercises: [
            Exercise(name: 'Deadlift', sets: 3, reps: 8, weight: 60),
            Exercise(name: 'Shoulder Press', sets: 3, reps: 10, weight: 30),
            Exercise(name: 'Bicep Curls', sets: 3, reps: 12, weight: 15),
          ],
        ),
        WorkoutSession(
          day: 'Friday',
          exercises: [
            Exercise(name: 'Leg Press', sets: 3, reps: 12, weight: 80),
            Exercise(name: 'Chest Fly', sets: 3, reps: 12, weight: 20),
            Exercise(name: 'Tricep Extension', sets: 3, reps: 12, weight: 15),
          ],
        ),
      ],
      adherenceData: {
        '2023-06-01': 'full',
        '2023-06-03': 'partial',
        '2023-06-05': 'full',
        '2023-06-08': 'missed',
        '2023-06-10': 'full',
        '2023-06-12': 'full',
      },
    ),
    WorkoutPlan(
      id: '2',
      name: 'Advanced Hypertrophy',
      description:
          'High-volume training program designed for muscle growth and definition.',
      createdBy: '3', // Trainer
      duration: '12 weeks',
      exerciseCount: 24,
      sessions: [
        WorkoutSession(
          day: 'Monday',
          exercises: [
            Exercise(name: 'Incline Bench Press', sets: 4, reps: 8, weight: 70),
            Exercise(name: 'Cable Fly', sets: 4, reps: 12, weight: 25),
            Exercise(name: 'Dips', sets: 3, reps: 12, weight: 0),
            Exercise(name: 'Tricep Pushdown', sets: 3, reps: 15, weight: 20),
          ],
        ),
        WorkoutSession(
          day: 'Tuesday',
          exercises: [
            Exercise(name: 'Pull-ups', sets: 4, reps: 8, weight: 0),
            Exercise(name: 'Barbell Row', sets: 4, reps: 10, weight: 60),
            Exercise(name: 'Face Pull', sets: 3, reps: 15, weight: 15),
            Exercise(name: 'Hammer Curls', sets: 3, reps: 12, weight: 15),
          ],
        ),
        WorkoutSession(
          day: 'Thursday',
          exercises: [
            Exercise(name: 'Squats', sets: 5, reps: 5, weight: 100),
            Exercise(name: 'Romanian Deadlift', sets: 4, reps: 8, weight: 80),
            Exercise(name: 'Leg Extension', sets: 3, reps: 15, weight: 40),
            Exercise(name: 'Calf Raises', sets: 4, reps: 20, weight: 30),
          ],
        ),
        WorkoutSession(
          day: 'Friday',
          exercises: [
            Exercise(name: 'Overhead Press', sets: 4, reps: 8, weight: 45),
            Exercise(name: 'Lateral Raise', sets: 4, reps: 12, weight: 10),
            Exercise(name: 'Upright Row', sets: 3, reps: 12, weight: 30),
            Exercise(name: 'Shrugs', sets: 3, reps: 15, weight: 40),
          ],
        ),
      ],
      adherenceData: {
        '2023-06-01': 'full',
        '2023-06-02': 'full',
        '2023-06-04': 'missed',
        '2023-06-05': 'partial',
        '2023-06-08': 'full',
        '2023-06-09': 'full',
      },
    ),
    WorkoutPlan(
      id: '3',
      name: 'Fat Loss Circuit',
      description:
          'High-intensity circuit training designed to maximize calorie burn and fat loss.',
      createdBy: '1', // Member (custom plan)
      duration: '4 weeks',
      exerciseCount: 10,
      sessions: [
        WorkoutSession(
          day: 'Monday, Wednesday, Friday',
          exercises: [
            Exercise(name: 'Jumping Jacks', sets: 3, reps: 30, weight: 0),
            Exercise(name: 'Mountain Climbers', sets: 3, reps: 20, weight: 0),
            Exercise(name: 'Burpees', sets: 3, reps: 15, weight: 0),
            Exercise(name: 'Kettlebell Swings', sets: 3, reps: 20, weight: 16),
            Exercise(name: 'Box Jumps', sets: 3, reps: 15, weight: 0),
          ],
        ),
      ],
      adherenceData: {},
    ),
  ];

  // Diet Plans
  static final List<DietPlan> dietPlans = [
    DietPlan(
      id: '1',
      name: 'Muscle Building Diet',
      description:
          'High protein diet designed to support muscle growth and recovery.',
      createdBy: '3', // Trainer
      target: 'Muscle Gain',
      duration: '8 weeks',
      mealCount: 5,
      calories: 2800,
      meals: [
        Meal(
          name: 'Breakfast',
          foods: [
            Food(name: 'Oatmeal', quantity: '1 cup', calories: 300),
            Food(name: 'Protein Shake', quantity: '1 scoop', calories: 120),
            Food(name: 'Banana', quantity: '1 medium', calories: 105),
          ],
        ),
        Meal(
          name: 'Mid-Morning Snack',
          foods: [
            Food(name: 'Greek Yogurt', quantity: '1 cup', calories: 150),
            Food(name: 'Almonds', quantity: '1/4 cup', calories: 170),
          ],
        ),
        Meal(
          name: 'Lunch',
          foods: [
            Food(
              name: 'Grilled Chicken Breast',
              quantity: '6 oz',
              calories: 180,
            ),
            Food(name: 'Brown Rice', quantity: '1 cup', calories: 215),
            Food(name: 'Broccoli', quantity: '1 cup', calories: 55),
          ],
        ),
        Meal(
          name: 'Afternoon Snack',
          foods: [
            Food(name: 'Protein Bar', quantity: '1 bar', calories: 220),
            Food(name: 'Apple', quantity: '1 medium', calories: 95),
          ],
        ),
        Meal(
          name: 'Dinner',
          foods: [
            Food(name: 'Salmon', quantity: '6 oz', calories: 240),
            Food(name: 'Sweet Potato', quantity: '1 medium', calories: 115),
            Food(name: 'Spinach Salad', quantity: '2 cups', calories: 65),
          ],
        ),
      ],
      adherenceData: {
        '2023-06-01': 'full',
        '2023-06-02': 'partial',
        '2023-06-03': 'full',
        '2023-06-04': 'full',
        '2023-06-05': 'partial',
        '2023-06-06': 'missed',
        '2023-06-07': 'full',
      },
    ),
    DietPlan(
      id: '2',
      name: 'Weight Loss Diet',
      description:
          'Calorie-controlled diet with balanced macronutrients for healthy weight loss.',
      createdBy: '3', // Trainer
      target: 'Weight Loss',
      duration: '12 weeks',
      mealCount: 4,
      calories: 1800,
      meals: [
        Meal(
          name: 'Breakfast',
          foods: [
            Food(name: 'Egg Whites', quantity: '4 eggs', calories: 70),
            Food(name: 'Whole Wheat Toast', quantity: '1 slice', calories: 80),
            Food(name: 'Avocado', quantity: '1/4', calories: 80),
          ],
        ),
        Meal(
          name: 'Lunch',
          foods: [
            Food(
              name: 'Grilled Chicken Salad',
              quantity: '1 bowl',
              calories: 350,
            ),
            Food(name: 'Olive Oil Dressing', quantity: '1 tbsp', calories: 120),
          ],
        ),
        Meal(
          name: 'Snack',
          foods: [
            Food(name: 'Cottage Cheese', quantity: '1/2 cup', calories: 90),
            Food(name: 'Blueberries', quantity: '1/2 cup', calories: 40),
          ],
        ),
        Meal(
          name: 'Dinner',
          foods: [
            Food(name: 'Lean Ground Turkey', quantity: '4 oz', calories: 170),
            Food(name: 'Quinoa', quantity: '1/2 cup', calories: 110),
            Food(name: 'Roasted Vegetables', quantity: '1 cup', calories: 80),
          ],
        ),
      ],
      adherenceData: {
        '2023-06-01': 'full',
        '2023-06-02': 'full',
        '2023-06-03': 'partial',
        '2023-06-04': 'full',
        '2023-06-05': 'full',
        '2023-06-06': 'full',
        '2023-06-07': 'missed',
      },
    ),
  ];

  // Progress Data
  static final List<ProgressEntry> progressData = [
    ProgressEntry(
      userId: '1',
      date: DateTime(2023, 5, 1),
      bodyWeight: 185.0,
      exerciseProgress: [
        ExerciseProgress(exerciseName: 'Bench Press', weight: 135.0, reps: 8),
        ExerciseProgress(exerciseName: 'Squats', weight: 185.0, reps: 10),
      ],
    ),
    ProgressEntry(
      userId: '1',
      date: DateTime(2023, 5, 8),
      bodyWeight: 183.5,
      exerciseProgress: [
        ExerciseProgress(exerciseName: 'Bench Press', weight: 145.0, reps: 8),
        ExerciseProgress(exerciseName: 'Squats', weight: 195.0, reps: 10),
      ],
    ),
    ProgressEntry(
      userId: '1',
      date: DateTime(2023, 5, 15),
      bodyWeight: 182.0,
      exerciseProgress: [
        ExerciseProgress(exerciseName: 'Bench Press', weight: 155.0, reps: 8),
        ExerciseProgress(exerciseName: 'Squats', weight: 205.0, reps: 10),
      ],
    ),
    ProgressEntry(
      userId: '1',
      date: DateTime(2023, 5, 22),
      bodyWeight: 180.5,
      exerciseProgress: [
        ExerciseProgress(exerciseName: 'Bench Press', weight: 165.0, reps: 8),
        ExerciseProgress(exerciseName: 'Squats', weight: 215.0, reps: 10),
      ],
    ),
    ProgressEntry(
      userId: '1',
      date: DateTime(2023, 5, 29),
      bodyWeight: 179.0,
      exerciseProgress: [
        ExerciseProgress(exerciseName: 'Bench Press', weight: 175.0, reps: 8),
        ExerciseProgress(exerciseName: 'Squats', weight: 225.0, reps: 10),
      ],
    ),
    ProgressEntry(
      userId: '1',
      date: DateTime(2023, 6, 5),
      bodyWeight: 178.0,
      exerciseProgress: [
        ExerciseProgress(exerciseName: 'Bench Press', weight: 185.0, reps: 8),
        ExerciseProgress(exerciseName: 'Squats', weight: 235.0, reps: 10),
      ],
    ),
  ];

  // Payment Data
  static final List<Payment> payments = [
    Payment(
      id: '1',
      userId: '1',
      amount: 50.0,
      description: 'Monthly Gym Membership',
      date: DateTime(2023, 5, 1),
      status: 'Paid',
    ),
    Payment(
      id: '2',
      userId: '1',
      amount: 30.0,
      description: 'Personal Training Session',
      date: DateTime(2023, 5, 15),
      status: 'Paid',
    ),
    Payment(
      id: '3',
      userId: '1',
      amount: 50.0,
      description: 'Monthly Gym Membership',
      date: DateTime(2023, 6, 1),
      status: 'Due',
    ),
    Payment(
      id: '4',
      userId: '4',
      amount: 50.0,
      description: 'Monthly Gym Membership',
      date: DateTime(2023, 5, 1),
      status: 'Paid',
    ),
    Payment(
      id: '5',
      userId: '4',
      amount: 50.0,
      description: 'Monthly Gym Membership',
      date: DateTime(2023, 6, 1),
      status: 'Due',
    ),
  ];
}
