-- ============================================================
-- AJW 금형 관리 시스템 - Supabase Schema
-- Supabase SQL Editor에 붙여넣고 실행하세요
-- ============================================================

-- 1. molds 테이블 (금형 정보)
CREATE TABLE IF NOT EXISTS molds (
  part_id        TEXT PRIMARY KEY,
  category       TEXT,
  product_group  TEXT,
  mold_name      TEXT,
  cavity         TEXT,
  mfg_date       TEXT,
  domestic       TEXT,
  storage        TEXT,
  material       TEXT,
  warranty_shot  INTEGER,
  incoming_qty   INTEGER,
  prod_shot      INTEGER,
  life_ratio     FLOAT,
  note           TEXT,
  contract       TEXT,
  status         TEXT,
  last_prod_date TEXT,
  created_at     TIMESTAMPTZ DEFAULT NOW(),
  updated_at     TIMESTAMPTZ DEFAULT NOW()
);

-- 2. repair_history 테이블 (수리이력)
CREATE TABLE IF NOT EXISTS repair_history (
  id         BIGSERIAL PRIMARY KEY,
  part_id    TEXT NOT NULL REFERENCES molds(part_id) ON DELETE CASCADE,
  date       TEXT,
  type       TEXT,
  content    TEXT,
  worker     TEXT,
  days       TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Row Level Security 활성화
ALTER TABLE molds ENABLE ROW LEVEL SECURITY;
ALTER TABLE repair_history ENABLE ROW LEVEL SECURITY;

-- 4. anon key로 읽기/쓰기 허용 (사내 전용이므로 공개 허용)
CREATE POLICY "allow_all_molds"          ON molds          FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_repair_history" ON repair_history FOR ALL USING (true) WITH CHECK (true);

-- 5. updated_at 자동 갱신 트리거
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER molds_updated_at
  BEFORE UPDATE ON molds
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
