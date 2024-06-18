import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPage extends StatelessWidget {
  final DB = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    List symptoms = [
      {
        "id": 1,
        "english_name": "itching",
        "vietnamese_name": "Ngứa",
        "desc": "Cảm giác khó chịu, muốn gãi hoặc cào da.",
        "class": "Skin"
      },
      {
        "id": 2,
        "english_name": "skin_rash",
        "vietnamese_name": "Nổi mẩn",
        "desc":
            "Sự xuất hiện của vùng da có màu sắc, kích thước hoặc cấu trúc không bình thường.",
        "class": "Skin"
      },
      {
        "id": 3,
        "english_name": "nodal_skin_eruptions",
        "vietnamese_name": "Mụn da nang",
        "desc": "Sự xuất hiện của các điểm hoặc mụn trên da.",
        "class": "Skin"
      },
      {
        "id": 4,
        "english_name": "continuous_sneezing",
        "vietnamese_name": "Hắt hơi liên tục",
        "desc": "Tình trạng liên tục hắt hơi mà không ngừng.",
        "class": "Respiratory"
      },
      {
        "id": 5,
        "english_name": "shivering",
        "vietnamese_name": "Rùng mình",
        "desc": "Cảm giác run rẩy hoặc rung lắc do cảm lạnh hoặc sốt.",
        "class": "General"
      },
      {
        "id": 6,
        "english_name": "chills",
        "vietnamese_name": "Cảm lạnh",
        "desc": "Cảm giác lạnh lẽo hoặc run rẩy thường đi kèm với sốt.",
        "class": "General"
      },
      {
        "id": 7,
        "english_name": "joint_pain",
        "vietnamese_name": "Đau khớp",
        "desc": "Sự đau hoặc khó chịu ở các khớp của cơ thể.",
        "class": "Musculoskeletal"
      },
      {
        "id": 8,
        "english_name": "stomach_pain",
        "vietnamese_name": "Đau bụng",
        "desc": "Sự đau hoặc khó chịu ở phần bụng của cơ thể.",
        "class": "Gastrointestinal"
      },
      {
        "id": 9,
        "english_name": "acidity",
        "vietnamese_name": "Nồng độ axit cao",
        "desc":
            "Sự tăng lượng axit trong dạ dày, thường gây ra cảm giác đau rát hoặc nóng ở phía trên bụng.",
        "class": "Gastrointestinal"
      },
      {
        "id": 10,
        "english_name": "ulcers_on_tongue",
        "vietnamese_name": "Loét lưỡi",
        "desc":
            "Sự hình thành các vết loét hoặc vết thương trên bề mặt của lưỡi.",
        "class": "Oral"
      },
      {
        "id": 11,
        "english_name": "muscle_wasting",
        "vietnamese_name": "Suy giảm cơ bắp",
        "desc":
            "Sự mất mát hoặc suy giảm về khối lượng hoặc sức mạnh của cơ bắp.",
        "class": "Musculoskeletal"
      },
      {
        "id": 12,
        "english_name": "vomiting",
        "vietnamese_name": "Buồn nôn",
        "desc": "Sự hiện diện của việc nôn mửa hoặc làm nôn.",
        "class": "Gastrointestinal"
      },
      {
        "id": 13,
        "english_name": "burning_micturition",
        "vietnamese_name": "Tiểu đau rát",
        "desc": "Cảm giác đau hoặc nóng rát khi tiểu tiện.",
        "class": "Urinary"
      },
      {
        "id": 14,
        "english_name": "spotting_urination",
        "vietnamese_name": "Thấy máu khi tiểu tiện",
        "desc": "Sự xuất hiện của máu trong nước tiểu.",
        "class": "Urinary"
      },
      {
        "id": 15,
        "english_name": "fatigue",
        "vietnamese_name": "Mệt mỏi",
        "desc": "Sự mệt mỏi hoặc mệt nhọc không bình thường.",
        "class": "General"
      },
      {
        "id": 16,
        "english_name": "weight_gain",
        "vietnamese_name": "Tăng cân",
        "desc": "Sự tăng trọng lượng cơ thể một cách không bình thường.",
        "class": "General"
      },
      {
        "id": 17,
        "english_name": "anxiety",
        "vietnamese_name": "Lo lắng",
        "desc": "Tình trạng lo lắng hoặc căng thẳng tinh thần.",
        "class": "Psychological"
      },
      {
        "id": 18,
        "english_name": "cold_hands_and_feets",
        "vietnamese_name": "Tay chân lạnh",
        "desc": "Cảm giác lạnh hoặc ngứa ở tay và chân.",
        "class": "General"
      },
      {
        "id": 19,
        "english_name": "mood_swings",
        "vietnamese_name": "Thay đổi tâm trạng",
        "desc": "Thay đổi đột ngột và không dự đoán được trong tâm trạng.",
        "class": "Psychological"
      },
      {
        "id": 20,
        "english_name": "weight_loss",
        "vietnamese_name": "Giảm cân",
        "desc": "Sự mất cân nặng cơ thể một cách không bình thường.",
        "class": "General"
      },
      {
        "id": 21,
        "english_name": "restlessness",
        "vietnamese_name": "Lo lắng",
        "desc": "Tình trạng không yên định hoặc lo lắng.",
        "class": "Psychological"
      },
      {
        "id": 22,
        "english_name": "lethargy",
        "vietnamese_name": "Mất sinh lực",
        "desc":
            "Sự mất hứng thú hoặc năng lượng để thực hiện các hoạt động hàng ngày.",
        "class": "General"
      },
      {
        "id": 23,
        "english_name": "patches_in_throat",
        "vietnamese_name": "Vùng đỏ trên họng",
        "desc":
            "Sự xuất hiện của các vùng đỏ hoặc mảng trắng trên niêm mạc họng.",
        "class": "Respiratory"
      },
      {
        "id": 24,
        "english_name": "irregular_sugar_level",
        "vietnamese_name": "Mức đường huyết không đều",
        "desc": "Sự dao động không bình thường trong mức đường huyết.",
        "class": "Metabolic"
      },
      {
        "id": 25,
        "english_name": "cough",
        "vietnamese_name": "Ho",
        "desc": "Sự phát ra tiếng ho từ đường hô hấp.",
        "class": "Respiratory"
      },
      {
        "id": 26,
        "english_name": "high_fever",
        "vietnamese_name": "Sốt cao",
        "desc": "Nhiệt độ cơ thể cao hơn mức bình thường.",
        "class": "General"
      },
      {
        "id": 27,
        "english_name": "sunken_eyes",
        "vietnamese_name": "Mắt hốc",
        "desc": "Sự xuất hiện của mắt hốc hoặc mắt mờ do mất nước.",
        "class": "General"
      },
      {
        "id": 28,
        "english_name": "breathlessness",
        "vietnamese_name": "Khó thở",
        "desc": "Tình trạng khó thở hoặc không đủ không khí khi hít thở.",
        "class": "Respiratory"
      },
      {
        "id": 29,
        "english_name": "sweating",
        "vietnamese_name": "Đổ mồ hôi",
        "desc": "Sự xuất hiện của mồ hôi trên bề mặt da.",
        "class": "General"
      },
      {
        "id": 30,
        "english_name": "dehydration",
        "vietnamese_name": "Mất nước",
        "desc": "Sự mất nước cơ thể đến mức độ nguy hiểm.",
        "class": "General"
      },
      {
        "id": 31,
        "english_name": "indigestion",
        "vietnamese_name": "Khó tiêu hóa",
        "desc": "Sự khó chịu hoặc không thoải mái sau khi ăn.",
        "class": "Gastrointestinal"
      },
      {
        "id": 32,
        "english_name": "headache",
        "vietnamese_name": "Đau đầu",
        "desc": "Sự cảm giác đau hoặc khó chịu ở phần đầu của cơ thể.",
        "class": "General"
      },
      {
        "id": 33,
        "english_name": "yellowish_skin",
        "vietnamese_name": "Da vàng",
        "desc": "Sự xuất hiện của màu vàng trên da.",
        "class": "Skin"
      },
      {
        "id": 34,
        "english_name": "dark_urine",
        "vietnamese_name": "Nước tiểu đậm",
        "desc": "Sự xuất hiện của màu sắc đậm hoặc nổi bật trong nước tiểu.",
        "class": "Urinary"
      },
      {
        "id": 35,
        "english_name": "nausea",
        "vietnamese_name": "Buồn nôn",
        "desc": "Sự cảm giác muốn nôn mửa.",
        "class": "Gastrointestinal"
      },
      {
        "id": 36,
        "english_name": "loss_of_appetite",
        "vietnamese_name": "Mất cảm giác ngon miệng",
        "desc": "Sự mất sự hứng thú hoặc mong muốn ăn uống.",
        "class": "Gastrointestinal"
      },
      {
        "id": 37,
        "english_name": "pain_behind_the_eyes",
        "vietnamese_name": "Đau sau mắt",
        "desc": "Sự cảm giác đau hoặc không thoải mái ở phía sau mắt.",
        "class": "General"
      },
      {
        "id": 38,
        "english_name": "back_pain",
        "vietnamese_name": "Đau lưng",
        "desc": "Sự đau hoặc khó chịu ở phần sau của cơ thể.",
        "class": "Musculoskeletal"
      },
      {
        "id": 39,
        "english_name": "constipation",
        "vietnamese_name": "Táo bón",
        "desc": "Sự khó khăn hoặc mất khả năng đi ngoài.",
        "class": "Gastrointestinal"
      },
      {
        "id": 40,
        "english_name": "abdominal_pain",
        "vietnamese_name": "Đau bụng",
        "desc": "Sự đau hoặc không thoải mái ở phần bụng của cơ thể.",
        "class": "Gastrointestinal"
      },
      {
        "id": 41,
        "english_name": "diarrhoea",
        "vietnamese_name": "Tiêu chảy",
        "desc": "Sự xuất hiện của phân lỏng hoặc phân nước.",
        "class": "Gastrointestinal"
      },
      {
        "id": 42,
        "english_name": "mild_fever",
        "vietnamese_name": "Sốt nhẹ",
        "desc":
            "Nhiệt độ cơ thể cao hơn bình thường nhưng không quá nghiêm trọng.",
        "class": "General"
      },
      {
        "id": 43,
        "english_name": "yellow_urine",
        "vietnamese_name": "Nước tiểu màu vàng",
        "desc": "Sự xuất hiện của màu vàng trong nước tiểu.",
        "class": "Urinary"
      },
      {
        "id": 44,
        "english_name": "yellowing_of_eyes",
        "vietnamese_name": "Mắt vàng",
        "desc": "Sự xuất hiện của màu vàng trên mắt.",
        "class": "General"
      },
      {
        "id": 45,
        "english_name": "acute_liver_failure",
        "vietnamese_name": "Thất bại gan cấp tính",
        "desc": "Sự mất chức năng của gan xảy ra nhanh chóng và nghiêm trọng.",
        "class": "General"
      },
      {
        "id": 46,
        "english_name": "fluid_overload",
        "vietnamese_name": "Tăng nhiều chất lỏng",
        "desc": "Sự tích tụ quá mức của chất lỏng trong cơ thể.",
        "class": "General"
      },
      {
        "id": 47,
        "english_name": "swelling_of_stomach",
        "vietnamese_name": "Sưng bụng",
        "desc": "Sự phình to hoặc sưng của phần bụng.",
        "class": "Gastrointestinal"
      },
      {
        "id": 48,
        "english_name": "swelled_lymph_nodes",
        "vietnamese_name": "Tăng kích thước của nút hạch",
        "desc":
            "Sự phình to hoặc tăng kích thước của các nút hạch trong cơ thể.",
        "class": "General"
      },
      {
        "id": 49,
        "english_name": "malaise",
        "vietnamese_name": "Mệt mỏi",
        "desc": "Tình trạng mệt mỏi hoặc không thoải mái.",
        "class": "General"
      },
      {
        "id": 50,
        "english_name": "blurred_and_distorted_vision",
        "vietnamese_name": "Tầm nhìn mờ và méo mó",
        "desc": "Sự mờ hoặc méo mó trong tầm nhìn.",
        "class": "General"
      },
      {
        "id": 51,
        "english_name": "phlegm",
        "vietnamese_name": "Dịch nhầy",
        "desc": "Dịch nhầy hoặc dịch đàm trong đường hô hấp.",
        "class": "Respiratory"
      },
      {
        "id": 52,
        "english_name": "throat_irritation",
        "vietnamese_name": "Kích ứng họng",
        "desc": "Sự kích ứng hoặc cảm giác đau trong họng.",
        "class": "Respiratory"
      },
      {
        "id": 53,
        "english_name": "redness_of_eyes",
        "vietnamese_name": "Mắt đỏ",
        "desc": "Sự xuất hiện của màu đỏ trong mắt.",
        "class": "General"
      },
      {
        "id": 54,
        "english_name": "sinus_pressure",
        "vietnamese_name": "Áp lực xoang",
        "desc": "Áp lực hoặc đau ở vùng xương trán và má.",
        "class": "Respiratory"
      },
      {
        "id": 55,
        "english_name": "runny_nose",
        "vietnamese_name": "Chảy nước mũi",
        "desc": "Sự chảy nước từ mũi.",
        "class": "Respiratory"
      },
      {
        "id": 56,
        "english_name": "congestion",
        "vietnamese_name": "Nghẹt mũi",
        "desc": "Sự tắc nghẽn hoặc khó thở thông qua mũi.",
        "class": "Respiratory"
      },
      {
        "id": 57,
        "english_name": "chest_pain",
        "vietnamese_name": "Đau ngực",
        "desc": "Sự cảm giác đau hoặc khó chịu ở phần ngực.",
        "class": "Cardiovascular"
      },
      {
        "id": 58,
        "english_name": "weakness_in_limbs",
        "vietnamese_name": "Yếu đuối ở chi",
        "desc": "Sự mất sức mạnh hoặc sự yếu đuối ở các chi của cơ thể.",
        "class": "Musculoskeletal"
      },
      {
        "id": 59,
        "english_name": "fast_heart_rate",
        "vietnamese_name": "Nhịp tim nhanh",
        "desc": "Tốc độ hoạt động của tim nhanh hơn mức bình thường.",
        "class": "Cardiovascular"
      },
      {
        "id": 60,
        "english_name": "pain_during_bowel_movements",
        "vietnamese_name": "Đau khi đi đại tiện",
        "desc": "Sự đau hoặc không thoải mái khi đi tiểu hoặc đi đại tiện.",
        "class": "Gastrointestinal"
      },
      {
        "id": 61,
        "english_name": "pain_in_anal_region",
        "vietnamese_name": "Đau vùng hậu môn",
        "desc": "Sự đau hoặc không thoải mái ở vùng hậu môn.",
        "class": "Gastrointestinal"
      },
      {
        "id": 62,
        "english_name": "bloody_stool",
        "vietnamese_name": "Phân có máu",
        "desc": "Sự xuất hiện của máu trong phân.",
        "class": "Gastrointestinal"
      },
      {
        "id": 63,
        "english_name": "irritation_in_anus",
        "vietnamese_name": "Kích ứng ở hậu môn",
        "desc": "Sự kích ứng hoặc cảm giác đau ở vùng hậu môn.",
        "class": "Gastrointestinal"
      },
      {
        "id": 64,
        "english_name": "neck_pain",
        "vietnamese_name": "Đau cổ",
        "desc": "Sự cảm giác đau hoặc không thoải mái ở phần cổ của cơ thể.",
        "class": "Musculoskeletal"
      },
      {
        "id": 65,
        "english_name": "dizziness",
        "vietnamese_name": "Chóng mặt",
        "desc": "Sự cảm giác mất cân bằng hoặc quay vòng.",
        "class": "General"
      },
      {
        "id": 66,
        "english_name": "cramps",
        "vietnamese_name": "Co giật",
        "desc": "Sự co lại hoặc co cứng đau đớn trong cơ bắp.",
        "class": "Musculoskeletal"
      },
      {
        "id": 67,
        "english_name": "bruising",
        "vietnamese_name": "Bầm tím",
        "desc": "Sự xuất hiện của các vết bầm tím hoặc vết bầm tím trên da.",
        "class": "Skin"
      },
      {
        "id": 68,
        "english_name": "obesity",
        "vietnamese_name": "Béo phì",
        "desc": "Sự tích tụ mỡ cơ thể đến mức độ quá mức.",
        "class": "General"
      },
      {
        "id": 69,
        "english_name": "swollen_legs",
        "vietnamese_name": "Chân sưng",
        "desc": "Sự phình to hoặc sưng của chân.",
        "class": "General"
      },
      {
        "id": 70,
        "english_name": "swollen_blood_vessels",
        "vietnamese_name": "Tĩnh mạch sưng to",
        "desc": "Sự phình to hoặc sưng của các mạch máu.",
        "class": "Cardiovascular"
      },
      {
        "id": 71,
        "english_name": "puffy_face_and_eyes",
        "vietnamese_name": "Mặt và mắt sưng phồng",
        "desc": "Sự phình to hoặc sưng của mặt và mắt.",
        "class": "General"
      },
      {
        "id": 72,
        "english_name": "enlarged_thyroid",
        "vietnamese_name": "Tăng kích thước của tuyến giáp",
        "desc": "Sự phình to hoặc tăng kích thước của tuyến giáp.",
        "class": "Endocrine"
      },
      {
        "id": 73,
        "english_name": "brittle_nails",
        "vietnamese_name": "Móng yếu",
        "desc": "Sự dễ gãy hoặc yếu của móng tay hoặc móng chân.",
        "class": "Skin"
      },
      {
        "id": 74,
        "english_name": "swollen_extremeties",
        "vietnamese_name": "Các chi sưng",
        "desc": "Sự phình to hoặc sưng của các chi của cơ thể.",
        "class": "General"
      },
      {
        "id": 75,
        "english_name": "excessive_hunger",
        "vietnamese_name": "Thèm ăn quá mức",
        "desc": "Sự cảm giác muốn ăn nhiều hơn mức bình thường.",
        "class": "General"
      },
      {
        "id": 76,
        "english_name": "extra_marital_contacts",
        "vietnamese_name": "Quan hệ ngoại tình",
        "desc": "Tình trạng tham gia vào quan hệ tình dục ngoài hôn nhân.",
        "class": "Social"
      },
      {
        "id": 77,
        "english_name": "drying_and_tingling_lips",
        "vietnamese_name": "Môi khô và nhức",
        "desc": "Sự khô và nhức hoặc cảm giác kích thích trên môi.",
        "class": "General"
      },
      {
        "id": 78,
        "english_name": "slurred_speech",
        "vietnamese_name": "Nói không rõ ràng",
        "desc": "Sự thất thoát hoặc mờ mịt trong lời nói.",
        "class": "Neurological"
      },
      {
        "id": 79,
        "english_name": "knee_pain",
        "vietnamese_name": "Đau đầu gối",
        "desc":
            "Sự cảm giác đau hoặc không thoải mái ở phần đầu gối của cơ thể.",
        "class": "Musculoskeletal"
      },
      {
        "id": 80,
        "english_name": "hip_joint_pain",
        "vietnamese_name": "Đau khớp háng",
        "desc":
            "Sự cảm giác đau hoặc không thoải mái ở phần khớp háng của cơ thể.",
        "class": "Musculoskeletal"
      },
      {
        "id": 81,
        "english_name": "muscle_weakness",
        "vietnamese_name": "Yếu cơ bắp",
        "desc": "Sự mất sức mạnh hoặc sự yếu đuối trong cơ bắp.",
        "class": "Musculoskeletal"
      },
      {
        "id": 82,
        "english_name": "stiff_neck",
        "vietnamese_name": "Cổ cứng",
        "desc":
            "Sự cảm giác cứng cổ hoặc không thoải mái ở phần cổ của cơ thể.",
        "class": "Musculoskeletal"
      },
      {
        "id": 83,
        "english_name": "swelling_joints",
        "vietnamese_name": "Sưng khớp",
        "desc": "Sự phình to hoặc sưng của các khớp của cơ thể.",
        "class": "Musculoskeletal"
      },
      {
        "id": 84,
        "english_name": "movement_stiffness",
        "vietnamese_name": "Sự cứng khớp khi di chuyển",
        "desc":
            "Sự khó khăn hoặc cảm giác cứng khi di chuyển các khớp của cơ thể.",
        "class": "Musculoskeletal"
      },
      {
        "id": 85,
        "english_name": "spinning_movements",
        "vietnamese_name": "Cảm giác xoay vòng",
        "desc": "Cảm giác xoay vòng hoặc lảo đảo không kiểm soát được.",
        "class": "Neurological"
      },
      {
        "id": 86,
        "english_name": "loss_of_balance",
        "vietnamese_name": "Mất cân bằng",
        "desc": "Sự mất khả năng duy trì cân bằng.",
        "class": "Neurological"
      },
      {
        "id": 87,
        "english_name": "unsteadiness",
        "vietnamese_name": "Không ổn định",
        "desc": "Tình trạng không ổn định hoặc không ổn định khi đứng hoặc đi.",
        "class": "General"
      },
      {
        "id": 88,
        "english_name": "weakness_of_one_body_side",
        "vietnamese_name": "Yếu một bên cơ thể",
        "desc": "Sự mất sức mạnh hoặc yếu đuối chỉ ở một bên của cơ thể.",
        "class": "Neurological"
      },
      {
        "id": 89,
        "english_name": "loss_of_smell",
        "vietnamese_name": "Mất khả năng cảm nhận mùi",
        "desc": "Sự mất khả năng cảm nhận hoặc nhận biết mùi.",
        "class": "Neurological"
      },
      {
        "id": 90,
        "english_name": "bladder_discomfort",
        "vietnamese_name": "Khó chịu ở bàng quang",
        "desc": "Sự đau hoặc không thoải mái trong bàng quang.",
        "class": "Urinary"
      },
      {
        "id": 91,
        "english_name": "foul_smell_of_urine",
        "vietnamese_name": "Mùi nước tiểu hôi",
        "desc": "Mùi hôi khó chịu của nước tiểu.",
        "class": "Urinary"
      },
      {
        "id": 92,
        "english_name": "continuous_feel_of_urine",
        "vietnamese_name": "Cảm giác tiểu tiện liên tục",
        "desc": "Cảm giác muốn tiểu tiện liên tục mặc dù đã đi tiểu.",
        "class": "Urinary"
      },
      {
        "id": 93,
        "english_name": "passage_of_gases",
        "vietnamese_name": "Hiện tượng thải khí",
        "desc": "Sự phát ra khí hoặc khí từ đường ruột.",
        "class": "Gastrointestinal"
      },
      {
        "id": 94,
        "english_name": "internal_itching",
        "vietnamese_name": "Ngứa nội tiết",
        "desc": "Cảm giác ngứa trong cơ thể hoặc bên trong cơ thể.",
        "class": "General"
      },
      {
        "id": 95,
        "english_name": "toxic_look_(typhos)",
        "vietnamese_name": "Vẻ bề ngoài độc hại (typhos)",
        "desc": "Vẻ bề ngoài độc hại hoặc không khỏe mạnh.",
        "class": "General"
      },
      {
        "id": 96,
        "english_name": "depression",
        "vietnamese_name": "Trầm cảm",
        "desc": "Tình trạng tinh thần suy sụp hoặc chán nản.",
        "class": "Psychological"
      },
      {
        "id": 97,
        "english_name": "irritability",
        "vietnamese_name": "Dễ cáu kỉnh",
        "desc": "Tình trạng dễ cáu kỉnh hoặc dễ cáu giận.",
        "class": "Psychological"
      },
      {
        "id": 98,
        "english_name": "muscle_pain",
        "vietnamese_name": "Đau cơ bắp",
        "desc": "Sự đau hoặc không thoải mái trong cơ bắp.",
        "class": "Musculoskeletal"
      },
      {
        "id": 99,
        "english_name": "altered_sensorium",
        "vietnamese_name": "Thay đổi ý thức",
        "desc": "Sự thay đổi trong trạng thái ý thức hoặc nhận thức.",
        "class": "Neurological"
      },
      {
        "id": 100,
        "english_name": "red_spots_over_body",
        "vietnamese_name": "Vết đỏ trên cơ thể",
        "desc": "Sự xuất hiện của các vết đỏ trên da hoặc bề mặt cơ thể.",
        "class": "Skin"
      },
      {
        "id": 101,
        "english_name": "belly_pain",
        "vietnamese_name": "Đau bụng dưới",
        "desc": "Sự đau hoặc không thoải mái ở phần bụng dưới của cơ thể.",
        "class": "Gastrointestinal"
      },
      {
        "id": 102,
        "english_name": "abnormal_menstruation",
        "vietnamese_name": "Kinh nguyệt không bình thường",
        "desc":
            "Sự xuất hiện của chu kỳ kinh nguyệt không bình thường hoặc biến đổi.",
        "class": "Reproductive"
      },
      {
        "id": 103,
        "english_name": "dischromic _patches",
        "vietnamese_name": "Vùng da không đều màu",
        "desc": "Sự xuất hiện của các vùng da không đều màu.",
        "class": "Skin"
      },
      {
        "id": 104,
        "english_name": "watering_from_eyes",
        "vietnamese_name": "Mắt chảy nước",
        "desc": "Sự chảy nước từ mắt.",
        "class": "General"
      },
      {
        "id": 105,
        "english_name": "increased_appetite",
        "vietnamese_name": "Tăng cảm giác ngon miệng",
        "desc": "Sự tăng sự hứng thú hoặc mong muốn ăn uống.",
        "class": "Gastrointestinal"
      },
      {
        "id": 106,
        "english_name": "polyuria",
        "vietnamese_name": "Tiểu nhiều",
        "desc": "Sự phát ra nước tiểu nhiều hơn bình thường.",
        "class": "Urinary"
      },
      {
        "id": 107,
        "english_name": "family_history",
        "vietnamese_name": "Tiền sử gia đình",
        "desc": "Lịch sử bệnh lý trong gia đình người bệnh.",
        "class": "General"
      },
      {
        "id": 108,
        "english_name": "mucoid_sputum",
        "vietnamese_name": "Đàm nhầy",
        "desc": "Sự phát ra dịch nhầy từ đường hô hấp.",
        "class": "Respiratory"
      },
      {
        "id": 109,
        "english_name": "rusty_sputum",
        "vietnamese_name": "Đàm có màu gỉ sét",
        "desc": "Sự xuất hiện của dịch nhầy có màu gỉ sét.",
        "class": "Respiratory"
      },
      {
        "id": 110,
        "english_name": "lack_of_concentration",
        "vietnamese_name": "Thiếu tập trung",
        "desc": "Sự mất tập trung hoặc không tập trung.",
        "class": "Psychological"
      },
      {
        "id": 111,
        "english_name": "visual_disturbances",
        "vietnamese_name": "Rối loạn thị giác",
        "desc": "Sự rối loạn hoặc thay đổi trong tầm nhìn.",
        "class": "Neurological"
      },
      {
        "id": 112,
        "english_name": "receiving_blood_transfusion",
        "vietnamese_name": "Nhận truyền máu",
        "desc": "Hành động nhận máu từ người khác.",
        "class": "General"
      },
      {
        "id": 113,
        "english_name": "receiving_unsterile_injections",
        "vietnamese_name": "Nhận tiêm không sạch",
        "desc": "Hành động nhận tiêm từ người khác mà không đảm bảo vệ sinh.",
        "class": "General"
      },
      {
        "id": 114,
        "english_name": "coma",
        "vietnamese_name": "Hôn mê",
        "desc": "Trạng thái không có ý thức hoặc tỉnh táo.",
        "class": "Neurological"
      },
      {
        "id": 115,
        "english_name": "stomach_bleeding",
        "vietnamese_name": "Chảy máu dạ dày",
        "desc": "Sự xuất hiện của máu trong dạ dày.",
        "class": "Gastrointestinal"
      },
      {
        "id": 116,
        "english_name": "distention_of_abdomen",
        "vietnamese_name": "Sưng bụng",
        "desc": "Sự phình to hoặc sưng của bụng.",
        "class": "Gastrointestinal"
      },
      {
        "id": 117,
        "english_name": "history_of_alcohol_consumption",
        "vietnamese_name": "Lịch sử tiêu thụ rượu",
        "desc": "Lịch sử tiêu thụ rượu hoặc chất cồn.",
        "class": "General"
      },
      {
        "id": 118,
        "english_name": "fluid_overload",
        "vietnamese_name": "Tăng nhiều chất lỏng",
        "desc": "Sự tích tụ quá mức của chất lỏng trong cơ thể.",
        "class": "General"
      },
      {
        "id": 119,
        "english_name": "blood_in_sputum",
        "vietnamese_name": "Máu trong đàm",
        "desc": "Sự xuất hiện của máu trong dịch nhầy.",
        "class": "Respiratory"
      },
      {
        "id": 120,
        "english_name": "prominent_veins_on_calf",
        "vietnamese_name": "Tĩnh mạch nổi trên bắp chân",
        "desc": "Sự phình to hoặc nổi rõ các tĩnh mạch trên bắp chân.",
        "class": "Cardiovascular"
      },
      {
        "id": 121,
        "english_name": "palpitations",
        "vietnamese_name": "Rung đập tim",
        "desc": "Sự cảm giác nhịp tim mạnh hoặc không bình thường.",
        "class": "Cardiovascular"
      },
      {
        "id": 122,
        "english_name": "painful_walking",
        "vietnamese_name": "Đau khi đi bộ",
        "desc": "Sự đau hoặc không thoải mái khi đi bộ.",
        "class": "Musculoskeletal"
      },
      {
        "id": 123,
        "english_name": "pus_filled_pimples",
        "vietnamese_name": "Mụn mủ",
        "desc": "Sự xuất hiện của mụn có chứa mủ.",
        "class": "Skin"
      },
      {
        "id": 124,
        "english_name": "blackheads",
        "vietnamese_name": "Mụn đầu đen",
        "desc": "Sự xuất hiện của mụn đầu đen trên da.",
        "class": "Skin"
      },
      {
        "id": 125,
        "english_name": "scurring",
        "vietnamese_name": "Nứt nẻ da",
        "desc": "Sự xuất hiện của vảy da hoặc da bong tróc.",
        "class": "Skin"
      },
      {
        "id": 126,
        "english_name": "skin_peeling",
        "vietnamese_name": "Da bong tróc",
        "desc": "Sự bong tróc hoặc mất lớp ngoài cùng của da.",
        "class": "Skin"
      },
      {
        "id": 127,
        "english_name": "silver_like_dusting",
        "vietnamese_name": "Bụi bạc như bụi",
        "desc": "Sự xuất hiện của bụi màu bạc như bụi.",
        "class": "Skin"
      },
      {
        "id": 128,
        "english_name": "small_dents_in_nails",
        "vietnamese_name": "Vết lõm nhỏ trên móng tay",
        "desc":
            "Sự xuất hiện của các vết lõm nhỏ trên móng tay hoặc móng chân.",
        "class": "Skin"
      },
      {
        "id": 129,
        "english_name": "inflammatory_nails",
        "vietnamese_name": "Viêm móng",
        "desc": "Sự viêm nhiễm hoặc viêm nhiễm của móng tay hoặc móng chân.",
        "class": "Skin"
      },
      {
        "id": 130,
        "english_name": "blister",
        "vietnamese_name": "Bong tróc",
        "desc":
            "Sự xuất hiện của các vết bong tróc hoặc vết bong tróc trên da.",
        "class": "Skin"
      },
      {
        "id": 131,
        "english_name": "red_sore_around_nose",
        "vietnamese_name": "Vết đỏ xung quanh mũi",
        "desc": "Sự xuất hiện của các vết đỏ hoặc vết đỏ xung quanh mũi.",
        "class": "Skin"
      },
      {
        "id": 132,
        "english_name": "yellow_crust_ooze",
        "vietnamese_name": "Chảy dịch vàng",
        "desc": "Sự xuất hiện của dịch vàng hoặc vết sưng đỏ.",
        "class": "Skin"
      }
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Gửi dữ liệu lên Firestore'),
              onPressed: () {
                symptoms.forEach((symptom) {
                  sendDataToFirestore(symptom);
                });
              },
            ),
            SizedBox(height: 16), // Khoảng cách giữa hai nút
            ElevatedButton(
              child: Text('Lấy dữ liệu từ Firestore'),
              onPressed: getDatafromFirestore,
            ),
            SizedBox(height: 16), // Khoảng cách giữa hai nút
            ElevatedButton(
              child: Text('Xoá collection symptoms'),
              onPressed: getDatafromFirestore,
            ),
          ],
        ),
      ),
    );
  }

  void sendDataToFirestore(jsonData) {
    DB
        .collection("symptoms")
        .doc(jsonData['id'].toString())
        .set(jsonData)
        .onError((e, _) => print("Error writing document: $e"));
  }

  void deleteDataToFirestore(jsonData) {
    DB
        .collection("symptoms")
        .doc(jsonData['id'].toString())
        .set(jsonData)
        .onError((e, _) => print("Error writing document: $e"));
  }

  void getDatafromFirestore() {
    DB.collection("symptoms").get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
        print("số lượng data là: " + querySnapshot.docs.length.toString());
      },
      onError: (e) => print("Error completing: $e"),
    );
  }
}
