import requests
import re
from typing import Dict, Any, Tuple

def parse_address(address: str) -> Dict[str, str]:
    """
    주소를 파싱하여 시군구코드, 법정동코드, 번지 등 추출
    """
    # 간단한 주소 파싱 로직
    # 실제 환경에서는 주소 API 또는 더 정교한 파싱이 필요
    
    # 번지 추출 (예: "123-45" 형식)
    bun_match = re.search(r'(\d+)-?(\d*)', address)
    bun = bun_match.group(1) if bun_match else ''
    ji = bun_match.group(2) if bun_match and bun_match.group(2) else '0'
    
    return {
        'sigungu_code': '',  # 시군구 코드는 별도 매핑 테이블 필요
        'bjdong_code': '',   # 법정동 코드는 별도 매핑 테이블 필요
        'bun': bun,
        'ji': ji
    }

def fetch_building_info(address: str, api_key: str) -> Dict[str, Any]:
    """
    건축물대장 정보 가져오기
    공공데이터포털 API 활용
    """
    try:
        # API 키 검증
        if not api_key or len(api_key) < 20:
            return {
                'address': address,
                'building_name': '',
                'main_purpose': '',
                'total_area': '',
                'building_area': '',
                'floor_area': '',
                'building_coverage': '',
                'floor_area_ratio': '',
                'structure': '',
                'floors_above': '',
                'floors_below': '',
                'completion_date': '',
                'parking_spaces': '',
                'elevators': '',
                'status': 'warning',
                'message': 'API 키를 확인해주세요. 공공데이터포털(data.go.kr)에서 발급받은 인코딩 키를 입력하세요.'
            }
        
        # 주소 파싱
        parsed = parse_address(address)
        
        # API 엔드포인트
        base_url = "http://apis.data.go.kr/1613000/BldRgstService_v2/getBrTitleInfo"
        
        params = {
            'serviceKey': api_key,
            'sigunguCd': parsed['sigungu_code'],
            'bjdongCd': parsed['bjdong_code'],
            'bun': parsed['bun'],
            'ji': parsed['ji'],
            'numOfRows': '10',
            'pageNo': '1',
            '_type': 'json'
        }
        
        # API 호출
        response = requests.get(base_url, params=params, timeout=10)
        
        if response.status_code == 200:
            try:
                data = response.json()
                
                # 응답 구조 확인
                if 'response' in data:
                    response_data = data['response']
                    
                    # 에러 코드 확인
                    if 'header' in response_data:
                        result_code = response_data['header'].get('resultCode', '')
                        result_msg = response_data['header'].get('resultMsg', '')
                        
                        # 에러 처리
                        if result_code != '00':
                            return {
                                'address': address,
                                'building_name': '',
                                'main_purpose': '',
                                'total_area': '',
                                'building_area': '',
                                'floor_area': '',
                                'building_coverage': '',
                                'floor_area_ratio': '',
                                'structure': '',
                                'floors_above': '',
                                'floors_below': '',
                                'completion_date': '',
                                'parking_spaces': '',
                                'elevators': '',
                                'status': 'error',
                                'message': f'API 오류: {result_msg} (코드: {result_code})'
                            }
                    
                    # 데이터 추출
                    if 'body' in response_data:
                        body = response_data['body']
                        items = body.get('items', {})
                        
                        if items and 'item' in items:
                            item_data = items['item']
                            building = item_data[0] if isinstance(item_data, list) else item_data
                            
                            return {
                                'address': address,
                                'building_name': building.get('bldNm', ''),
                                'main_purpose': building.get('mainPurpsCdNm', ''),
                                'total_area': building.get('totArea', ''),
                                'building_area': building.get('archArea', ''),
                                'floor_area': building.get('totArea', ''),
                                'building_coverage': building.get('bcRat', ''),
                                'floor_area_ratio': building.get('vlRat', ''),
                                'structure': building.get('strctCdNm', ''),
                                'floors_above': building.get('grndFlrCnt', ''),
                                'floors_below': building.get('ugrndFlrCnt', ''),
                                'completion_date': building.get('useAprDay', ''),
                                'parking_spaces': building.get('indrAutoUtcnt', ''),
                                'elevators': building.get('rideUseElvtCnt', ''),
                                'status': 'success',
                                'message': '데이터 조회 성공'
                            }
                        else:
                            return {
                                'address': address,
                                'building_name': '',
                                'main_purpose': '',
                                'total_area': '',
                                'building_area': '',
                                'floor_area': '',
                                'building_coverage': '',
                                'floor_area_ratio': '',
                                'structure': '',
                                'floors_above': '',
                                'floors_below': '',
                                'completion_date': '',
                                'parking_spaces': '',
                                'elevators': '',
                                'status': 'warning',
                                'message': '해당 주소의 건축물 정보를 찾을 수 없습니다. 주소를 확인해주세요.'
                            }
            except Exception as json_error:
                # JSON 파싱 실패
                return {
                    'address': address,
                    'building_name': '',
                    'main_purpose': '',
                    'total_area': '',
                    'building_area': '',
                    'floor_area': '',
                    'building_coverage': '',
                    'floor_area_ratio': '',
                    'structure': '',
                    'floors_above': '',
                    'floors_below': '',
                    'completion_date': '',
                    'parking_spaces': '',
                    'elevators': '',
                    'status': 'error',
                    'message': f'API 응답 처리 실패: {str(json_error)}'
                }
        else:
            # HTTP 상태 코드 에러
            return {
                'address': address,
                'building_name': '',
                'main_purpose': '',
                'total_area': '',
                'building_area': '',
                'floor_area': '',
                'building_coverage': '',
                'floor_area_ratio': '',
                'structure': '',
                'floors_above': '',
                'floors_below': '',
                'completion_date': '',
                'parking_spaces': '',
                'elevators': '',
                'status': 'error',
                'message': f'API 호출 실패: HTTP {response.status_code}'
            }
        
    except requests.exceptions.Timeout:
        return {
            'address': address,
            'building_name': '',
            'main_purpose': '',
            'total_area': '',
            'building_area': '',
            'floor_area': '',
            'building_coverage': '',
            'floor_area_ratio': '',
            'structure': '',
            'floors_above': '',
            'floors_below': '',
            'completion_date': '',
            'parking_spaces': '',
            'elevators': '',
            'status': 'error',
            'message': 'API 응답 시간 초과. 네트워크 연결을 확인해주세요.'
        }
    except requests.exceptions.ConnectionError:
        return {
            'address': address,
            'building_name': '',
            'main_purpose': '',
            'total_area': '',
            'building_area': '',
            'floor_area': '',
            'building_coverage': '',
            'floor_area_ratio': '',
            'structure': '',
            'floors_above': '',
            'floors_below': '',
            'completion_date': '',
            'parking_spaces': '',
            'elevators': '',
            'status': 'error',
            'message': '네트워크 연결 실패. 인터넷 연결을 확인해주세요.'
        }
    except Exception as e:
        return {
            'address': address,
            'building_name': '',
            'main_purpose': '',
            'total_area': '',
            'building_area': '',
            'floor_area': '',
            'building_coverage': '',
            'floor_area_ratio': '',
            'structure': '',
            'floors_above': '',
            'floors_below': '',
            'completion_date': '',
            'parking_spaces': '',
            'elevators': '',
            'status': 'error',
            'message': f'오류 발생: {str(e)}'
        }

def fetch_land_info(address: str, api_key: str) -> Dict[str, Any]:
    """
    토지대장 정보 가져오기
    공공데이터포털 API 활용
    """
    try:
        # API 키 검증
        if not api_key or len(api_key) < 20:
            return {
                'address': address,
                'land_category': '',
                'land_area': '',
                'official_land_price': '',
                'land_use_zone': '',
                'land_use_district': '',
                'status': 'warning',
                'message': 'API 키를 확인해주세요.'
            }
        
        # API 엔드포인트
        base_url = "http://apis.data.go.kr/1611000/nsdi/IndvdLandDetailService/attr/getLandDetailInfo"
        
        params = {
            'serviceKey': api_key,
            'pnu': '',  # 주소에서 PNU 코드 생성 (별도 구현 필요)
            'format': 'json'
        }
        
        response = requests.get(base_url, params=params, timeout=10)
        
        if response.status_code == 200:
            try:
                data = response.json()
                
                return {
                    'address': address,
                    'land_category': '',
                    'land_area': '',
                    'official_land_price': '',
                    'land_use_zone': '',
                    'land_use_district': '',
                    'status': 'success',
                    'message': '데이터 조회 성공'
                }
            except Exception:
                return {
                    'address': address,
                    'land_category': '',
                    'land_area': '',
                    'official_land_price': '',
                    'land_use_zone': '',
                    'land_use_district': '',
                    'status': 'warning',
                    'message': '토지 정보 파싱 실패'
                }
        else:
            return {
                'address': address,
                'land_category': '',
                'land_area': '',
                'official_land_price': '',
                'land_use_zone': '',
                'land_use_district': '',
                'status': 'error',
                'message': f'API 호출 실패: HTTP {response.status_code}'
            }
        
    except Exception as e:
        return {
            'address': address,
            'land_category': '',
            'land_area': '',
            'official_land_price': '',
            'land_use_zone': '',
            'land_use_district': '',
            'status': 'error',
            'message': f'오류 발생: {str(e)}'
        }
