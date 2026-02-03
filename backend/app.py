from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import os
import requests
from datetime import datetime
from pptx_generator import generate_briefing_pptx, generate_print_pptx
from public_data_api import fetch_building_info, fetch_land_info

app = Flask(__name__)
CORS(app)

# 업로드 폴더 설정
UPLOAD_FOLDER = os.path.join(os.path.dirname(__file__), '..', 'public', 'uploads')
OUTPUT_FOLDER = os.path.join(os.path.dirname(__file__), '..', 'output')
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

@app.route('/api/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'ok', 'message': '상업용 부동산 제안서 생성 API 서버'})

@app.route('/api/fetch-property-data', methods=['POST'])
def fetch_property_data():
    """공공데이터포털에서 건축물/토지 정보 가져오기"""
    try:
        data = request.json
        address = data.get('address')
        api_key = data.get('api_key')
        
        if not address or not api_key:
            return jsonify({'error': '주소와 API 키가 필요합니다.'}), 400
        
        # 건축물대장 정보 가져오기
        building_info = fetch_building_info(address, api_key)
        
        # 토지대장 정보 가져오기
        land_info = fetch_land_info(address, api_key)
        
        return jsonify({
            'success': True,
            'building_info': building_info,
            'land_info': land_info
        })
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/upload-image', methods=['POST'])
def upload_image():
    """이미지 업로드"""
    try:
        if 'image' not in request.files:
            return jsonify({'error': '이미지 파일이 필요합니다.'}), 400
        
        file = request.files['image']
        image_type = request.form.get('type', 'main')  # main, interior, other
        
        if file.filename == '':
            return jsonify({'error': '파일이 선택되지 않았습니다.'}), 400
        
        # 파일명 생성 (타임스탬프 포함)
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f"{image_type}_{timestamp}_{file.filename}"
        filepath = os.path.join(UPLOAD_FOLDER, filename)
        
        file.save(filepath)
        
        return jsonify({
            'success': True,
            'filename': filename,
            'url': f'/uploads/{filename}'
        })
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/generate-pptx', methods=['POST'])
def generate_pptx():
    """PPTX 제안서 생성"""
    try:
        data = request.json
        template_type = data.get('template_type', 'briefing')  # briefing or print
        property_data = data.get('property_data', {})
        
        # 파일명 생성
        project_name = property_data.get('project_name', '제안서')
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f"{project_name}_{template_type}_{timestamp}.pptx"
        output_path = os.path.join(OUTPUT_FOLDER, filename)
        
        # PPTX 생성
        if template_type == 'briefing':
            generate_briefing_pptx(property_data, output_path)
        else:
            generate_print_pptx(property_data, output_path)
        
        return send_file(
            output_path,
            as_attachment=True,
            download_name=filename,
            mimetype='application/vnd.openxmlformats-officedocument.presentationml.presentation'
        )
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/genspark-prompts', methods=['GET'])
def get_genspark_prompts():
    """GenSpark AI 프롬프트 가이드 제공"""
    prompts = [
        {
            'title': '부동산 특징 분석',
            'prompt': '서울특별시 강남구 대치동 890-12 (테헤란로 418) 위치한 상업용 오피스 빌딩의 투자 매력도와 핵심 특징을 전문적이고 고급스럽게 3-5문장으로 작성해줘. 입지, 교통, 주변 환경을 중심으로 설명해줘.'
        },
        {
            'title': '투자 하이라이트',
            'prompt': '[주소]에 위치한 [건물유형] 부동산의 투자 하이라이트를 5가지로 요약해줘. 각 항목은 간결하고 임팩트 있게 작성하고, 투자자 관점에서 매력적으로 표현해줘.'
        },
        {
            'title': '입지 분석',
            'prompt': '[주소] 부동산의 입지적 장점을 교통(지하철, 버스, 도로), 상권, 개발 호재 측면에서 분석해줘. 전문 중개사가 고객에게 설명하는 톤으로 작성해줘.'
        },
        {
            'title': '수익성 분석',
            'prompt': '[건물명] 건물의 임대 수익성과 자산 가치 상승 가능성을 분석해줘. 현재 시장 상황과 향후 전망을 포함해서 투자자를 설득할 수 있게 작성해줘.'
        },
        {
            'title': '매각 제안 메시지',
            'prompt': '[건물명], 매각가 [금액]원의 상업용 부동산 매각 제안서에 들어갈 오프닝 메시지를 작성해줘. 투자자의 관심을 끌 수 있도록 전문적이고 고급스럽게 2-3문장으로 작성해줘.'
        }
    ]
    
    return jsonify({'prompts': prompts})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
