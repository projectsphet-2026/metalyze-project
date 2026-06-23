-- =======================================================
-- Metalyze Project - Admin Secure Deletion Setup
-- =======================================================
-- คำแนะนำ: คัดลอกโค้ดทั้งหมดนี้ไปวางและรันในแถบ "SQL Editor" ของ Supabase Console
-- ท่านสามารถแก้ไขคำว่า 'admin1234' เป็นรหัสผ่านที่ท่านต้องการใช้งานจริง

-- 1. ฟังก์ชันยืนยันรหัสผ่านแอดมินสำหรับการเข้าสู่ระบบหน้าเว็บ
CREATE OR REPLACE FUNCTION public.verify_admin_password(admin_pass TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    -- เช็คความถูกต้องของรหัสผ่านโดยเทียบค่าตรงๆ ในตัวแปร
    -- หากต้องการความปลอดภัยระดับสูง แนะนำแก้ไขรหัสผ่านตรงนี้
    RETURN admin_pass = 'metalyzeprojectS2006';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. ฟังก์ชันการลบข้อมูลรายงานคุณภาพน้ำแบบปลอดภัย (ลบข้อมูลรูปภาพและคอมเมนต์ที่เกี่ยวเนื่องทั้งหมดผ่าน CASCADE)
CREATE OR REPLACE FUNCTION public.delete_water_report(report_id UUID, admin_pass TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    -- ตรวจสอบรหัสผ่านก่อนดำเนินการลบข้อมูลจริง
    IF admin_pass = 'metalyzeprojectS2006' THEN
        DELETE FROM public.water_reports WHERE id = report_id;
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. ฟังก์ชันการลบความคิดเห็นแบบปลอดภัย (ใช้ได้ทั้งคอมเมนต์ทั่วไปและคอมเมนต์ในรายงาน)
CREATE OR REPLACE FUNCTION public.delete_comment(comment_id UUID, admin_pass TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    -- ตรวจสอบรหัสผ่านก่อนดำเนินการลบข้อมูลจริง
    IF admin_pass = 'metalyzeprojectS2006' THEN
        DELETE FROM public.comments WHERE id = comment_id;
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
