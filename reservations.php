<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once 'db_test.php';
function isRoomAvailable($pdo, $room_id, $date, $start_time, $end_time) {
    $stmt = $pdo->prepare("
        SELECT id FROM room_reservations
        WHERE room_id = ? AND date = ? AND status != 'rejected'
        AND start_time < ? AND end_time > ?
    ");
    $stmt->execute([$room_id, $date, $end_time, $start_time]);
    return $stmt->rowCount() === 0; }

    function isLecturerAvailable($pdo, $lecturer_id, $date, $start_time, $end_time) {
    $stmt = $pdo->prepare("
        SELECT id FROM room_reservations
        WHERE lecturer_id = ? AND date = ? AND status != 'rejected'
        AND start_time < ? AND end_time > ?
    ");
    $stmt->execute([$lecturer_id, $date, $end_time, $start_time]);
    return $stmt->rowCount() === 0; }

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        $lecturer_id = isset($_GET['lecturer_id']) ? intval($_GET['lecturer_id']) : null;

        $query = "
            SELECT
                res.id,
                res.lecturer_id,
                res.room_id,
                res.date,
                res.start_time,
                res.end_time,
                res.status,
                res.created_at,
                r.name as rooms_name,
                l.name as lecturers_name
            FROM
                room_reservations res
            LEFT JOIN
                rooms r ON res.room_id = r.id
            LEFT JOIN
                lecturers l ON res.lecturer_id = l.id
        ";

        if ($lecturer_id) {
            $query .= " WHERE res.lecturer_id = :lecturer_id";
        }

        $query .= " ORDER BY res.date DESC, res.start_time";

        $stmt = $pdo->prepare($query);

        if ($lecturer_id) {
            $stmt->bindValue(':lecturer_id', $lecturer_id, PDO::PARAM_INT);
        }

        $stmt->execute();

        $reservations = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($reservations);
        break;

    case 'PUT':
        $data = json_decode(file_get_contents("php://input"));
        if (!empty($data->id) && !empty($data->status)) {
            $allowed_statuses = ['pending', 'approved', 'rejected'];
            if (in_array($data->status, $allowed_statuses)) {
                $stmt = $pdo->prepare("UPDATE room_reservations SET status = ? WHERE id = ?");
                if ($stmt->execute([$data->status, $data->id])) {
                    echo json_encode(['status' => 'success', 'message' => 'Reservation status updated.']);
                } else {
                    http_response_code(503);
                    echo json_encode(['status' => 'error', 'message' => 'Unable to update reservation.']);
                }
            } else {
                http_response_code(400);
                echo json_encode(['status' => 'error', 'message' => 'Invalid status value.']);
            }
        } else {
            http_response_code(400);
            echo json_encode(['status' => 'error', 'message' => 'Incomplete data. ID and status are required.']);
        }
        break;

    default:
        http_response_code(405);
        echo json_encode(['status' => 'error', 'message' => 'Method not allowed for reservations.']);
        break;
        
        case 'DELETE':
        $data = json_decode(file_get_contents("php://input"));

        if (!empty($data->id) && !empty($data->lecturer_id)) {
            // 1. Kontrol Adımı
            $checkStmt = $pdo->prepare(query: "SELECT * FROM room_reservations WHERE id = ? AND lecturer_id = ? AND status = 'pending'");
            $checkStmt->execute([$data->id, $data->lecturer_id]);

            if ($checkStmt->rowCount() > 0) {
                // 2. Silme Adımı
                $deleteStmt = $pdo->prepare("DELETE FROM room_reservations WHERE id = ?");
                if ($deleteStmt->execute([$data->id])) {
                    echo json_encode(['status' => 'success', 'message' => 'Reservation deleted successfully.']);
                } else {
                    http_response_code(503);
                    echo json_encode(['status' => 'error', 'message' => 'Unable to delete reservation.']);
                }
            } else {
                http_response_code(403);
                echo json_encode([
                    'status' => 'error',
                    'message' => 'Bu işlemi yapmaya yetkiniz yok veya rezervasyon zaten onaylanmış.'
                ]);
            }
        } else {
            http_response_code(400);
            echo json_encode([
                'status' => 'error',
                'message' => 'Eksik veri. Hem id hem de lecturer_id gereklidir.'
            ]);
        }
        break;
    }
?>

