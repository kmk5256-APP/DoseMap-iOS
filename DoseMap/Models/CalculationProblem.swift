import Foundation

struct CalculationProblem: Identifiable, Codable {
    let id: UUID
    let region: RegionType
    let question: String
    let correctAnswer: Double
    let unit: String
    let acceptableTolerance: Double
    let steps: [String]
    let tip: String
    let difficulty: Int // 1-3
    
    init(
        region: RegionType,
        question: String,
        correctAnswer: Double,
        unit: String,
        steps: [String],
        tip: String,
        difficulty: Int = 1,
        tolerance: Double = 0.1
    ) {
        self.id = UUID()
        self.region = region
        self.question = question
        self.correctAnswer = correctAnswer
        self.unit = unit
        self.steps = steps
        self.tip = tip
        self.difficulty = difficulty
        self.acceptableTolerance = tolerance
    }
    
    func isCorrect(_ answer: Double) -> Bool {
        abs(answer - correctAnswer) <= acceptableTolerance
    }
}

// MARK: - Problem Bank
extension CalculationProblem {
    static let allProblems: [CalculationProblem] = [
        // ORAL LANDS
        CalculationProblem(
            region: .oral,
            question: "Order: Acetaminophen 650 mg PO. Available: 325 mg tablets. How many tablets will you administer?",
            correctAnswer: 2,
            unit: "tablets",
            steps: [
                "Identify: Desired = 650 mg, Have = 325 mg/tablet, Quantity = 1 tablet",
                "Formula: (Desired ÷ Have) × Quantity",
                "650 mg ÷ 325 mg = 2",
                "2 × 1 tablet = 2 tablets"
            ],
            tip: "Always write the units. They should cancel to leave only 'tablets'.",
            difficulty: 1
        ),
        CalculationProblem(
            region: .oral,
            question: "Order: Amoxicillin 500 mg PO. Available: 250 mg/5 mL suspension. How many mL will you give?",
            correctAnswer: 10,
            unit: "mL",
            steps: [
                "Desired = 500 mg, Have = 250 mg per 5 mL",
                "(500 mg ÷ 250 mg) × 5 mL = 2 × 5 = 10 mL",
                "Or dimensional analysis: 500 mg × (5 mL / 250 mg) = 10 mL"
            ],
            tip: "For liquids the 'Quantity' is the volume that contains the 'Have' dose.",
            difficulty: 1
        ),
        CalculationProblem(
            region: .oral,
            question: "Order: Digoxin 0.25 mg PO. Available: 0.125 mg tablets. How many tablets?",
            correctAnswer: 2,
            unit: "tablets",
            steps: [
                "0.25 mg ÷ 0.125 mg/tablet = 2 tablets",
                "Be careful with decimals — trailing zeros matter for safety."
            ],
            tip: "Never leave a trailing zero (write 0.25 not .25). Leading zero is required.",
            difficulty: 1
        ),
        CalculationProblem(
            region: .oral,
            question: "Order: Ibuprofen 600 mg. Available: 200 mg tablets. How many tablets?",
            correctAnswer: 3,
            unit: "tablets",
            steps: ["600 ÷ 200 = 3 tablets"],
            tip: "Simple division when Quantity = 1.",
            difficulty: 1
        ),
        CalculationProblem(
            region: .oral,
            question: "Order: Furosemide 80 mg PO. Available: 40 mg tablets. How many tablets?",
            correctAnswer: 2,
            unit: "tablets",
            steps: ["80 mg ÷ 40 mg = 2 tablets"],
            tip: "Classic ratio & proportion or Desired/Have.",
            difficulty: 1
        ),
        
        // IV RIVER (mL/hr)
        CalculationProblem(
            region: .ivFlow,
            question: "Infuse 1,000 mL of Normal Saline over 8 hours. What is the rate in mL/hr?",
            correctAnswer: 125,
            unit: "mL/hr",
            steps: [
                "Total volume ÷ Total time in hours",
                "1,000 mL ÷ 8 hr = 125 mL/hr"
            ],
            tip: "Always convert time to hours for mL/hr answers.",
            difficulty: 1
        ),
        CalculationProblem(
            region: .ivFlow,
            question: "Order: 500 mL of D5W over 4 hours. Calculate the mL/hr rate.",
            correctAnswer: 125,
            unit: "mL/hr",
            steps: ["500 ÷ 4 = 125 mL/hr"],
            tip: "Same formula every time for continuous infusions.",
            difficulty: 1
        ),
        CalculationProblem(
            region: .ivFlow,
            question: "A patient needs 250 mL of antibiotic to run over 90 minutes. What rate (mL/hr) should you set the pump?",
            correctAnswer: 166.7,
            unit: "mL/hr",
            steps: [
                "Convert 90 min to hours: 90 ÷ 60 = 1.5 hr",
                "250 mL ÷ 1.5 hr = 166.67 → 166.7 mL/hr (or 167 depending on policy)"
            ],
            tip: "Convert minutes to hours by dividing by 60 before dividing volume.",
            difficulty: 2,
            tolerance: 1.0
        ),
        CalculationProblem(
            region: .ivFlow,
            question: "Infuse 750 mL over 6 hours. Rate in mL/hr?",
            correctAnswer: 125,
            unit: "mL/hr",
            steps: ["750 ÷ 6 = 125 mL/hr"],
            tip: "Clean division problems are common.",
            difficulty: 1
        ),
        
        // DRIP FALLS (gtt/min)
        CalculationProblem(
            region: .drip,
            question: "Infuse 100 mL over 30 minutes. Drop factor = 15 gtt/mL. What is the drip rate in gtt/min?",
            correctAnswer: 50,
            unit: "gtt/min",
            steps: [
                "Formula: (Volume mL ÷ Time min) × Drop factor",
                "(100 ÷ 30) × 15 = 3.333 × 15 = 50 gtt/min"
            ],
            tip: "Round to the nearest whole drop. Time must be in minutes.",
            difficulty: 2
        ),
        CalculationProblem(
            region: .drip,
            question: "1,000 mL NS over 8 hours, drop factor 15 gtt/mL. gtt/min?",
            correctAnswer: 31,
            unit: "gtt/min",
            steps: [
                "Time in minutes = 8 × 60 = 480 min",
                "(1,000 × 15) ÷ 480 = 15,000 ÷ 480 = 31.25 → 31 gtt/min"
            ],
            tip: "Always convert hours to minutes for gtt/min calculations.",
            difficulty: 2
        ),
        CalculationProblem(
            region: .drip,
            question: "500 mL over 4 hours with a 10 gtt/mL set. Calculate gtt/min.",
            correctAnswer: 21,
            unit: "gtt/min",
            steps: [
                "4 hr = 240 min",
                "(500 × 10) ÷ 240 = 5,000 ÷ 240 ≈ 20.83 → 21 gtt/min"
            ],
            tip: "Microdrip sets are usually 60 gtt/mL; macro are 10, 15, or 20.",
            difficulty: 2
        ),
        
        // WEIGHT PEAK
        CalculationProblem(
            region: .weight,
            question: "Order: Medication 5 mg/kg. Patient weighs 70 kg. Available: 50 mg/mL. How many mL?",
            correctAnswer: 7,
            unit: "mL",
            steps: [
                "Total dose = 5 mg/kg × 70 kg = 350 mg",
                "Volume = 350 mg ÷ 50 mg/mL = 7 mL"
            ],
            tip: "Always calculate the total dose first, then convert to volume.",
            difficulty: 2
        ),
        CalculationProblem(
            region: .weight,
            question: "Patient weighs 154 lbs. Convert to kg (use 2.2).",
            correctAnswer: 70,
            unit: "kg",
            steps: ["154 ÷ 2.2 = 70 kg"],
            tip: "NCLEX almost always uses 2.2 lb = 1 kg.",
            difficulty: 1
        ),
        CalculationProblem(
            region: .weight,
            question: "Order: 2 mg/kg of a drug. Patient weighs 195 lbs. Available tablets are 25 mg. How many tablets? (Round to nearest whole)",
            correctAnswer: 7,
            unit: "tablets",
            steps: [
                "195 lbs ÷ 2.2 = 88.636 kg",
                "Dose = 2 mg × 88.636 ≈ 177.27 mg",
                "177.27 ÷ 25 ≈ 7.09 → 7 tablets"
            ],
            tip: "Do not round intermediate steps until the final answer if possible.",
            difficulty: 3,
            tolerance: 0.5
        ),
        
        // PEDIATRIC VALLEY
        CalculationProblem(
            region: .pediatric,
            question: "Child weighs 20 kg. Amoxicillin ordered at 40 mg/kg/day divided into 3 doses. What is the dose per administration in mg?",
            correctAnswer: 267,
            unit: "mg",
            steps: [
                "Daily dose = 40 mg/kg × 20 kg = 800 mg/day",
                "Per dose = 800 ÷ 3 ≈ 266.67 → 267 mg"
            ],
            tip: "Always calculate total daily first, then divide by number of doses.",
            difficulty: 2,
            tolerance: 1.0
        ),
        CalculationProblem(
            region: .pediatric,
            question: "A 6-year-old weighs 48 lbs. Order: Paracetamol 20 mg/kg. How many mg should be given?",
            correctAnswer: 436,
            unit: "mg",
            steps: [
                "48 ÷ 2.2 ≈ 21.818 kg",
                "20 mg × 21.818 ≈ 436.36 mg → 436 mg"
            ],
            tip: "Pediatric doses are almost always weight-based.",
            difficulty: 2,
            tolerance: 2.0
        ),
        
        // INFUSION HIGHLANDS
        CalculationProblem(
            region: .infusion,
            question: "Dopamine 5 mcg/kg/min for an 80 kg patient. Bag: 400 mg in 250 mL. What rate in mL/hr?",
            correctAnswer: 15,
            unit: "mL/hr",
            steps: [
                "Ordered = 5 mcg/kg/min × 80 kg = 400 mcg/min",
                "Convert to mg/min: 400 mcg ÷ 1000 = 0.4 mg/min",
                "Concentration = 400 mg / 250 mL = 1.6 mg/mL",
                "mL/min = 0.4 mg/min ÷ 1.6 mg/mL = 0.25 mL/min",
                "mL/hr = 0.25 × 60 = 15 mL/hr"
            ],
            tip: "Convert everything to consistent units (usually mg and minutes or hours).",
            difficulty: 3,
            tolerance: 0.5
        ),
        CalculationProblem(
            region: .infusion,
            question: "Heparin 12 units/kg/hr. Patient 184 lbs. Bag: 20,000 units in 500 mL. Rate in mL/hr?",
            correctAnswer: 25,
            unit: "mL/hr",
            steps: [
                "Weight kg = 184 / 2.2 ≈ 83.64 kg",
                "Dose/hr = 12 units × 83.64 ≈ 1003.6 units/hr",
                "Concentration = 20,000 units / 500 mL = 40 units/mL",
                "Rate = 1003.6 ÷ 40 ≈ 25.09 → 25 mL/hr"
            ],
            tip: "Heparin protocols are extremely common on NCLEX-style questions.",
            difficulty: 3,
            tolerance: 1.0
        ),
        
        // CONVERSION CROSSROADS
        CalculationProblem(
            region: .conversion,
            question: "Convert 2.5 kg to pounds (use 2.2).",
            correctAnswer: 5.5,
            unit: "lbs",
            steps: ["2.5 × 2.2 = 5.5 lbs"],
            tip: "kg × 2.2 = lbs; lbs ÷ 2.2 = kg.",
            difficulty: 1
        ),
        CalculationProblem(
            region: .conversion,
            question: "How many mL in 2.5 teaspoons? (1 tsp = 5 mL)",
            correctAnswer: 12.5,
            unit: "mL",
            steps: ["2.5 × 5 = 12.5 mL"],
            tip: "Know the common household to metric conversions cold.",
            difficulty: 1
        ),
        CalculationProblem(
            region: .conversion,
            question: "1 gram = how many milligrams?",
            correctAnswer: 1000,
            unit: "mg",
            steps: ["1 g = 1,000 mg (metric system is base-10)"],
            tip: "mg ↔ mcg is the most error-prone conversion (x1000).",
            difficulty: 1
        ),
        
        // ADVANCED (NAPLEX flavor)
        CalculationProblem(
            region: .advanced,
            question: "Calculate BSA using Mosteller: height 170 cm, weight 70 kg. (Round to 2 decimals)",
            correctAnswer: 1.82,
            unit: "m²",
            steps: [
                "Mosteller: BSA = √[(height_cm × weight_kg) / 3600]",
                "(170 × 70) / 3600 = 11900 / 3600 ≈ 3.3056",
                "√3.3056 ≈ 1.82 m²"
            ],
            tip: "Mosteller is the formula most often expected on exams.",
            difficulty: 2,
            tolerance: 0.02
        ),
        CalculationProblem(
            region: .advanced,
            question: "A 2% lidocaine solution means how many grams per 100 mL?",
            correctAnswer: 2,
            unit: "g",
            steps: ["2% w/v = 2 g solute per 100 mL solution"],
            tip: "% w/v is grams per 100 mL. Critical for concentration problems.",
            difficulty: 1
        ),
        CalculationProblem(
            region: .advanced,
            question: "Patient receives D5 1/2NS at 125 mL/hr. How many grams of dextrose in 24 hours?",
            correctAnswer: 150,
            unit: "g",
            steps: [
                "D5 = 5 g dextrose per 100 mL",
                "Volume in 24 hr = 125 × 24 = 3,000 mL",
                "(5 g / 100 mL) × 3,000 mL = 150 g"
            ],
            tip: "Percentage strength problems are pure proportional reasoning.",
            difficulty: 2
        )
    ]
    
    static func problems(for region: RegionType) -> [CalculationProblem] {
        allProblems.filter { $0.region == region }
    }
}
